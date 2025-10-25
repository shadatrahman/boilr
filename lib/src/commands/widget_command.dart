import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../utils/file_utils.dart';
import '../utils/logger.dart';

class WidgetCommand {
  void runWithArgs(List<String> args) {
    final parser = ArgParser()..addFlag('help', abbr: 'h', help: 'Print this usage information.');

    final results = parser.parse(args);

    if (results['help'] as bool) {
      print('boilr create widget - Create a ConsumerWidget with Riverpod integration');
      print('');
      print('Usage: boilr create widget <name>');
      print('');
      print('Arguments:');
      print('  name    The name of the widget to create');
      print('');
      print('This will create a ConsumerWidget with:');
      print('  - Automatic import statements (Flutter + Riverpod)');
      print('  - ConsumerWidget class structure');
      print('  - WidgetRef parameter handling');
      print('  - Riverpod state management ready');
      return;
    }

    if (results.rest.isEmpty) {
      print('Error: Widget name is required.');
      print('Usage: boilr create widget <name>');
      return;
    }

    final widgetName = results.rest[0];
    Logger.info('Creating widget: $widgetName');

    try {
      _generateWidget(widgetName);
      Logger.success('✅ Widget "$widgetName" created successfully!');
      Logger.info('Widget created in lib/shared/widgets/${widgetName.toLowerCase()}_widget.dart');
    } catch (e) {
      Logger.error('Failed to create widget: $e');
    }
  }

  void _generateWidget(String widgetName) {
    final className = _toPascalCase(widgetName);
    final fileName = '${widgetName.toLowerCase()}_widget.dart';
    final filePath = path.join('lib', 'shared', 'widgets', fileName);

    final widgetContent =
        '''import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class $className extends ConsumerWidget {
  const $className({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}''';

    FileUtils.writeFile(filePath, widgetContent);
  }

  String _toPascalCase(String input) {
    return input.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join('');
  }
}
