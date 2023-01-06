import 'package:cli_readme_builder/src/help_output_model.dart';
import 'package:test/test.dart';

const _mockCliName = 'mock_cli_name';
void main() {
  group('HelpOutputModel', () {
    test(
      'correctly parses top level command output',
      () async {
        const mockOutput = '''
Mock Description

Usage: $_mockCliName <command> [arguments]

Available commands:
  command_1   command 1 description
  command_2   command 2 description

Run "$_mockCliName help <command>" for more information about a command.
''';
        final model = await HelpOutputModel.fromHelpOutput(
          output: mockOutput,
          executablePath: '',
          parents: '',
          isTopLevel: true,
          recursive: false,
        );
        expect(model.commandName, equals(_mockCliName));
        expect(model.parents, isEmpty);
        expect(model.description, equals(['Mock Description']));
      },
    );
    test(
      'correctly parses branch command output',
      () async {
        const mockOutput = '''
Mock Description

Usage: $_mockCliName command_name <subcommand> [arguments]

Available subcommands:
  command_1   command 1 description
  command_2   command 2 description

Run "$_mockCliName help" to see global options.
''';
        final model = await HelpOutputModel.fromHelpOutput(
          output: mockOutput,
          executablePath: '',
          parents: _mockCliName,
          recursive: false,
        );
        expect(model.parents, equals('command_name'));
        expect(model.description, equals(['Mock Description']));
      },
    );
    test(
      'correctly parses leaf command output',
      () async {
        const mockOutput = '''
Mock Leaf Command description

Usage: $_mockCliName leaf_command [arguments]
-h, --help    Print this usage information.

Run "$_mockCliName help" to see global options.
''';
        final model = await HelpOutputModel.fromHelpOutput(
          output: mockOutput,
          executablePath: '',
          parents: _mockCliName,
          recursive: false,
        );
        expect(model.parents, equals('leaf_command'));
        expect(model.description, equals(['Mock Leaf Command description']));
      },
    );
  });
}
