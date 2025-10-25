import 'package:boilr/src/commands/create_command.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('boilr - Flutter project generator CLI');
    print('');
    print('Usage: boilr <command> [arguments]');
    print('');
    print('Available commands:');
    print('  create    Create Flutter projects, features, widgets, pages, and providers');
    print('');
    print('Run "boilr create --help" for more information about a command.');
    return;
  }

  if (arguments.contains('--version') || arguments.contains('-v')) {
    print('boilr version 1.0.0');
    return;
  }

  if (arguments.contains('--help') || arguments.contains('-h')) {
    print('boilr - Flutter project generator CLI');
    print('');
    print('Usage: boilr <command> [arguments]');
    print('');
    print('Available commands:');
    print('  create    Create Flutter projects, features, widgets, pages, and providers');
    print('');
    print('Run "boilr create --help" for more information about a command.');
    return;
  }

  final command = arguments[0];
  final commandArgs = arguments.skip(1).toList();

  if (command == 'create') {
    final createCommand = CreateCommand();
    createCommand.runWithArgs(commandArgs);
  } else {
    print('Unknown command: $command');
    print('Run "boilr --help" for available commands.');
  }
}
