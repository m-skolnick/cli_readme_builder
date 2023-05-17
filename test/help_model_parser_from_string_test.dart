import 'package:cli_readme_builder/src/help_model/help_model_parser_from_string.dart';
import 'package:cli_readme_builder/src/system_shell.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

const _mockCliName = 'mock_cli_name';
const _mockLeafCommandOutput = '''
Mock Leaf Command description

Usage: $_mockCliName leaf_command [arguments]
-h, --help    Print this usage information.

Run "$_mockCliName help" to see global options.
''';

class _MockSystemShell extends Mock implements SystemShell {}

void main() {
  group('HelpModelParserFromString', () {
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
        final model = await HelpModelParserFromString(
          output: mockOutput,
          executablePath: '',
          parents: '',
        ).parseModel(parseChildren: false);
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
      'child command output',
      () async {
        const mockOutput = '''
Mock Description

Usage: $_mockCliName <command> [arguments]

Available commands:
  command_1   command 1 description
  command_2   command 2 description

Run "$_mockCliName help <command>" for more information about a command.
''';
        final mockShell = _MockSystemShell();
        when(() => mockShell.run(any())).thenAnswer((_) async => _mockLeafCommandOutput);
        final model = await HelpModelParserFromString(
          output: mockOutput,
          executablePath: '',
          parents: '',
          shell: mockShell,
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
        expect(model.childCommandModels.first.entireHelpOutput, _mockLeafCommandOutput);
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
        final model = await HelpModelParserFromString(
          output: mockOutput,
          executablePath: '',
          parents: _mockCliName,
        ).parseModel(parseChildren: false);
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
        final model = await HelpModelParserFromString(
          output: _mockLeafCommandOutput,
          executablePath: '',
          parents: _mockCliName,
        ).parseModel(parseChildren: false);
        expect(model.commandName, equals('leaf_command'));
        expect(model.description, equals(['Mock Leaf Command description']));
        expect(model.entireHelpOutput, equals(_mockLeafCommandOutput));
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
        final model = await HelpModelParserFromString(
          output: mockOutput,
          executablePath: '',
          parents: '$_mockCliName branch_command',
        ).parseModel(parseChildren: false);
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
