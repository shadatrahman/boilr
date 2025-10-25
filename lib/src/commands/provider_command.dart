import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import '../utils/file_utils.dart';
import '../utils/logger.dart';

class ProviderCommand {
  void runWithArgs(List<String> args) {
    final parser = ArgParser()..addFlag('help', abbr: 'h', help: 'Print this usage information.');

    final results = parser.parse(args);

    if (results['help'] as bool) {
      print('boilr create provider - Create a Riverpod provider and state class');
      print('');
      print('Usage: boilr create provider <name>');
      print('');
      print('Arguments:');
      print('  name    The name of the provider to create');
      print('');
      print('This will create a Riverpod provider with:');
      print('  - StateProvider creation');
      print('  - Proper typing');
      print('  - State management patterns');
      return;
    }

    if (results.rest.isEmpty) {
      print('Error: Provider name is required.');
      print('Usage: boilr create provider <name>');
      return;
    }

    final providerName = results.rest[0];
    Logger.info('Creating provider: $providerName');

    try {
      _generateProvider(providerName);
      Logger.success('✅ Provider "$providerName" created successfully!');
      Logger.info('Provider created in lib/shared/providers/${providerName.toLowerCase()}_provider.dart');
    } catch (e) {
      Logger.error('Failed to create provider: $e');
    }
  }

  void _generateProvider(String providerName) {
    final className = _toPascalCase(providerName);
    final fileName = '${providerName.toLowerCase()}_provider.dart';
    final filePath = path.join('lib', 'shared', 'providers', fileName);

    final providerContent =
        '''import 'package:flutter_riverpod/flutter_riverpod.dart';

final ${providerName.toLowerCase()}Provider = StateProvider<bool>((ref) => false);

class $className {
  static void update${className}State(WidgetRef ref, bool value) {
    ref.read(${providerName.toLowerCase()}Provider.notifier).state = value;
  }
}''';

    FileUtils.writeFile(filePath, providerContent);
  }

  String _toPascalCase(String input) {
    return input.split('_').map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)).join('');
  }
}
