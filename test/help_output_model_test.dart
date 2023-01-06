import 'package:cli_readme_builder/src/help_output_model.dart';
import 'package:test/test.dart';

void main() {
  group('HelpOutputModel', () {
    test(
      'correctly parses top level command output',
      () {
        const mockOutput = '''
Mock Description

Usage: cli_name <command> [arguments]

Available commands:
  command_1   command 1 description
  command_2   command 2 description

Run "cli_name help <command>" for more information about a command.
''';
        final model = HelpOutputModel.fromHelpOutput(mockOutput);
        expect(model.name, equals('mock_name'));
        expect(model.description, equals('Mock Description'));
      },
    );
    test(
      'correctly parses branch command output',
      () {
        const mockOutput = '''
Mock Description

Usage: cli_name command_name <subcommand> [arguments]

Available subcommands:
  command_1   command 1 description
  command_2   command 2 description

Run "cli_name help" to see global options.
''';
        final model = HelpOutputModel.fromHelpOutput(mockOutput);
        expect(model.name, equals('mock_name'));
        expect(model.description, equals('Mock Description'));
      },
    );
  });
}
