import 'package:cli_readme_builder/src/help_model/help_model_parser.dart';
import 'package:test/test.dart';

const _mockCliName = 'mock_cli_name';
void main() {
  group('HelpModelParser', () {
    test(
      'correctly parses '
      'top level command output',
      () async {
        const mockOutput = '''
Mock Description

Usage: $_mockCliName <command> [arguments]

Available commands:
  command_1   command 1 description
  command_2   command 2 description

Run "$_mockCliName help <command>" for more information about a command.
''';
        final model = await HelpModelParser(
          output: mockOutput,
          executablePath: '',
          parents: '',
          recursive: false,
        ).parseModel();
        expect(model.commandName, equals(_mockCliName));
        expect(model.parents, isEmpty);
        expect(model.description, equals(['Mock Description']));
        expect(model.entireHelpOutput, equals(mockOutput));
        expect(
          model.childCommands,
          equals([
            'command_1',
            'command_2',
          ]),
        );
      },
    );
    test(
      'correctly parses '
      'branch command output',
      () async {
        const mockOutput = '''
Mock Description

Usage: $_mockCliName branch_command <subcommand> [arguments]

Available subcommands:
  command_1   command 1 description
  command_2   command 2 description

Run "$_mockCliName help" to see global options.
''';
        final model = await HelpModelParser(
          output: mockOutput,
          executablePath: '',
          parents: _mockCliName,
          recursive: false,
        ).parseModel();
        expect(model.commandName, equals('branch_command'));
        expect(model.description, equals(['Mock Description']));
        expect(model.entireHelpOutput, equals(mockOutput));
        expect(model.parents, equals(_mockCliName));
        expect(
          model.childCommands,
          equals([
            'command_1',
            'command_2',
          ]),
        );
      },
    );
    test(
      'correctly parses '
      'leaf command output',
      () async {
        const mockOutput = '''
Mock Leaf Command description

Usage: $_mockCliName leaf_command [arguments]
-h, --help    Print this usage information.

Run "$_mockCliName help" to see global options.
''';
        final model = await HelpModelParser(
          output: mockOutput,
          executablePath: '',
          parents: _mockCliName,
          recursive: false,
        ).parseModel();
        expect(model.commandName, equals('leaf_command'));
        expect(model.description, equals(['Mock Leaf Command description']));
        expect(model.entireHelpOutput, equals(mockOutput));
        expect(
          model.childCommands,
          isEmpty,
        );
      },
    );
    test(
      'correctly parses '
      'child of branch command output',
      () async {
        const mockOutput = '''
Mock Command description

Usage: $_mockCliName branch_command child_command [arguments]
-h, --help    Print this usage information.

Run "$_mockCliName help" to see global options.
''';
        final model = await HelpModelParser(
          output: mockOutput,
          executablePath: '',
          parents: '$_mockCliName branch_command',
          recursive: false,
        ).parseModel();
        expect(model.commandName, equals('child_command'));
        expect(model.description, equals(['Mock Command description']));
        expect(model.entireHelpOutput, equals(mockOutput));
        expect(
          model.childCommands,
          isEmpty,
        );
      },
    );
  });
}
