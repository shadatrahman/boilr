import 'project_command.dart';
import 'feature_command.dart';
import 'widget_command.dart';
import 'page_command.dart';
import 'provider_command.dart';

class CreateCommand {
  void runWithArgs(List<String> args) {
    if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
      print('boilr create - Create Flutter projects, features, widgets, pages, and providers');
      print('');
      print('Usage: boilr create <subcommand> [arguments]');
      print('');
      print('Available subcommands:');
      print('  project   Create a complete Flutter project with pre-configured packages');
      print('  feature   Create a feature module with clean architecture');
      print('  widget    Create a ConsumerWidget with Riverpod integration');
      print('  page      Create a Flutter screen with Riverpod integration');
      print('  provider  Create a Riverpod provider and state class');
      print('');
      print('Run "boilr create <subcommand> --help" for more information about a subcommand.');
      return;
    }

    final subcommand = args[0];
    final subcommandArgs = args.skip(1).toList();

    switch (subcommand) {
      case 'project':
        final projectCommand = ProjectCommand();
        projectCommand.runWithArgs(subcommandArgs);
        break;
      case 'feature':
        final featureCommand = FeatureCommand();
        featureCommand.runWithArgs(subcommandArgs);
        break;
      case 'widget':
        final widgetCommand = WidgetCommand();
        widgetCommand.runWithArgs(subcommandArgs);
        break;
      case 'page':
        final pageCommand = PageCommand();
        pageCommand.runWithArgs(subcommandArgs);
        break;
      case 'provider':
        final providerCommand = ProviderCommand();
        providerCommand.runWithArgs(subcommandArgs);
        break;
      default:
        print('Unknown subcommand: $subcommand');
        print('Run "boilr create --help" for available subcommands.');
    }
  }
}
