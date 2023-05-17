// ignore_for_file: strict_raw_type

import 'package:args/command_runner.dart';
import 'package:cli_readme_builder/src/help_model/help_model_parser_from_command_runner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

const _mockCliName = '_mockCliName';
const _mockCliDescription = '_mockCliDescription';
const _mockCommandName1 = '_mockCommandName1';
const _mockCommandName2 = '_mockCommandName2';
const _mockCommandDescription1 = '_mockCommandDescription1';
const _mockCommandDescription2 = '_mockCommandDescription2';
const _mockUsageOutput = '_mockUsageOutput';

class _MockCommandRunner extends Mock implements CommandRunner {}

class _MockCommand extends Mock implements Command {}

CommandRunner _buildMockCommandRunner() {
  final cmd1 = _MockCommand();
  when(() => cmd1.name).thenReturn(_mockCommandName1);
  when(() => cmd1.hidden).thenReturn(false);
  when(() => cmd1.description).thenReturn(_mockCommandDescription1);
  when(() => cmd1.usage).thenReturn(_mockUsageOutput);
  when(() => cmd1.subcommands).thenReturn({});

  final cmd2 = _MockCommand();
  when(() => cmd2.name).thenReturn(_mockCommandName2);
  when(() => cmd2.hidden).thenReturn(false);
  when(() => cmd2.description).thenReturn(_mockCommandDescription2);
  when(() => cmd2.usage).thenReturn(_mockUsageOutput);
  when(() => cmd2.subcommands).thenReturn({});

  final cmdRunner = _MockCommandRunner();
  when(() => cmdRunner.executableName).thenReturn(_mockCliName);
  when(() => cmdRunner.description).thenReturn(_mockCliDescription);
  when(() => cmdRunner.usage).thenReturn(_mockUsageOutput);
  when(() => cmdRunner.commands).thenReturn({
    cmd1.name: cmd1,
    cmd2.name: cmd2,
  });

  return cmdRunner;
}

void main() {
  group('HelpModelParserFromCommandRunner', () {
    test(
      'correctly parses '
      'top level command output',
      () {
        final cmdRunner = _buildMockCommandRunner();
        final model = HelpModelParserFromCommandRunner(
          commandRunner: cmdRunner,
        ).parseModel(
          parseChildren: false,
        );

        expect(model.commandName, equals(_mockCliName));
        expect(model.parents, isEmpty);
        expect(model.description, equals([_mockCliDescription]));
        expect(model.entireHelpOutput, equals(_mockUsageOutput));
        expect(
          model.childCommands,
          equals([
            _mockCommandName1,
            _mockCommandName2,
          ]),
        );
      },
    );
    test(
      'correctly parses '
      'child command',
      () {
        final cmdRunner = _buildMockCommandRunner();
        final model = HelpModelParserFromCommandRunner(
          commandRunner: cmdRunner,
        ).parseModel();

        expect(model.commandName, equals(_mockCliName));
        expect(model.parents, isEmpty);
        expect(model.description, equals([_mockCliDescription]));
        expect(model.entireHelpOutput, equals(_mockUsageOutput));
        expect(
          model.childCommands,
          equals([
            _mockCommandName1,
            _mockCommandName2,
          ]),
        );
        expect(model.childCommandModels.first.entireHelpOutput, _mockUsageOutput);
      },
    );
  });
}
