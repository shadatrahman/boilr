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
      Logger.success('✅ Page "$pageName" created successfully!');
      Logger.info('Page created in lib/shared/widgets/${pageName.toLowerCase()}_page.dart');
    } catch (e) {
      Logger.error('Failed to create page: $e');
    }
  }

  void _generatePage(String pageName) {
    final className = _toPascalCase(pageName);
    final fileName = '${pageName.toLowerCase()}_page.dart';
    final filePath = path.join('lib', 'shared', 'widgets', fileName);

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
        title: Text('$className'),
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

  String _toPascalCase(String input) {
    return input.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join('');
  }
}
