import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../utils/file_utils.dart';
import '../utils/logger.dart';

class PageCommand {
  void runWithArgs(List<String> args) {
    final parser = ArgParser()..addFlag('help', abbr: 'h', help: 'Print this usage information.');

    final results = parser.parse(args);

    if (results['help'] as bool) {
      print('boilr create page - Create a Flutter screen with Riverpod integration');
      print('');
      print('Usage: boilr create page <name>');
      print('');
      print('Arguments:');
      print('  name    The name of the page to create');
      print('');
      print('This will create a Flutter screen with:');
      print('  - Scaffold structure');
      print('  - Riverpod provider integration');
      print('  - ConsumerWidget implementation');
      print('  - State management setup');
      return;
    }

    if (results.rest.isEmpty) {
      print('Error: Page name is required.');
      print('Usage: boilr create page <name>');
      return;
    }

    final pageName = results.rest[0];
    Logger.info('Creating page: $pageName');

    try {
      _generatePage(pageName);
      _updateRouter(pageName);
      Logger.success('✅ Page "$pageName" created successfully!');
      Logger.info('Page created in lib/shared/pages/${pageName.toLowerCase()}_page.dart');
    } catch (e) {
      Logger.error('Failed to create page: $e');
    }
  }

  void _generatePage(String pageName) {
    final className = _toPascalCase(pageName);
    final fileName = '${pageName.toLowerCase()}_page.dart';
    final filePath = path.join('lib', 'shared', 'pages', fileName);

    final pageContent =
        '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ${pageName.toLowerCase()}Provider = StateProvider<bool>((ref) => false);

class $className extends ConsumerWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(${pageName.toLowerCase()}Provider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : const Text('$className'),
      ),
    );
  }
}''';

    FileUtils.writeFile(filePath, pageContent);
  }

  void _updateRouter(String pageName) {
    final routerPath = path.join('lib', 'core', 'router', 'app_router.dart');

    // Check if router file exists
    if (!File(routerPath).existsSync()) {
      Logger.warning('Router file not found. Skipping router update.');
      return;
    }

    try {
      final routerContent = File(routerPath).readAsStringSync();
      final entityName = _toPascalCase(pageName);
      final routePath = '/$pageName';
      final routeName = pageName;

      // Add import for the new page
      final importLine = "import '../../shared/pages/${pageName}_page.dart';";
      final contentWithImport = _addImportIfNotExists(routerContent, importLine);

      // Add route constants to Router class
      final contentWithConstants = _addRouteConstants(contentWithImport, pageName, routePath, routeName);

      // Add route to the routes array
      final finalContent = _addRouteToRouter(contentWithConstants, pageName, entityName, routePath, routeName);

      File(routerPath).writeAsStringSync(finalContent);
      Logger.success('✅ Router updated with new page route');
    } catch (e) {
      Logger.warning('Failed to update router: $e');
    }
  }

  String _addImportIfNotExists(String content, String importLine) {
    if (content.contains(importLine)) {
      return content;
    }

    // Find the last import statement and add after it
    final importRegex = RegExp(r"import '[^']+';");
    final matches = importRegex.allMatches(content).toList();

    if (matches.isNotEmpty) {
      final lastMatch = matches.last;
      final insertPosition = lastMatch.end;
      return '${content.substring(0, insertPosition)}\n$importLine${content.substring(insertPosition)}';
    }

    return content;
  }

  String _addRouteConstants(String content, String pageName, String routePath, String routeName) {
    final camelCaseName = _toCamelCase(pageName);
    final routeConstant =
        '''
  static const String $camelCaseName = '$routePath';
  static const String ${camelCaseName}Name = '$routeName';''';

    // Find the Router class and add constants before the closing brace
    final routerClassStart = content.indexOf('class Router {');
    if (routerClassStart == -1) {
      return content;
    }

    // Find the last static const in the Router class
    final lastConstMatch = RegExp(r"static const String \w+Name = '[^']+';").allMatches(content).toList();
    if (lastConstMatch.isNotEmpty) {
      final lastMatch = lastConstMatch.last;
      final insertPosition = lastMatch.end;
      return '${content.substring(0, insertPosition)}\n$routeConstant${content.substring(insertPosition)}';
    }

    return content;
  }

  String _addRouteToRouter(String content, String pageName, String entityName, String routePath, String routeName) {
    final camelCaseName = _toCamelCase(pageName);
    final routeToAdd =
        '''
  GoRoute(
        path: Router.$camelCaseName,
        name: Router.${camelCaseName}Name,
        builder: (context, state) => const $entityName(),
      ),''';

    // Find the routes array and add the new route
    final routesStart = content.indexOf('routes: [');
    if (routesStart == -1) {
      return content;
    }

    final routesEnd = content.indexOf('],', routesStart);
    if (routesEnd == -1) {
      return content;
    }

    // Insert the new route before the closing bracket
    final beforeRoutes = content.substring(0, routesEnd);
    final afterRoutes = content.substring(routesEnd);

    return '$beforeRoutes$routeToAdd\n    $afterRoutes';
  }

  String _toPascalCase(String input) {
    return input.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join('');
  }

  String _toCamelCase(String input) {
    final words = input.split('_');
    if (words.isEmpty) return input;
    return words[0].toLowerCase() + words.skip(1).map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join('');
  }
}
