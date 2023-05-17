// ignore_for_file: strict_raw_type

import 'package:args/command_runner.dart';
import 'package:cli_readme_builder/src/help_model/help_model_parser_from_command.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

const _mockCommandName1 = '_mockCommandName1';
const _mockCommandName2 = '_mockCommandName2';
const _mockCommandDescription1 = '_mockCommandDescription1';
const _mockCommandDescription2 = '_mockCommandDescription2';
const _mockUsageOutput = '_mockUsageOutput';

class _MockCommand extends Mock implements Command {}

Command _buildMockCommand() {
  final cmd1 = _MockCommand();
  when(() => cmd1.name).thenReturn(_mockCommandName1);
  when(() => cmd1.hidden).thenReturn(false);
  when(() => cmd1.usage).thenReturn(_mockUsageOutput);
  when(() => cmd1.description).thenReturn(_mockCommandDescription1);

  final cmd2 = _MockCommand();
  when(() => cmd2.name).thenReturn(_mockCommandName2);
  when(() => cmd2.hidden).thenReturn(false);
  when(() => cmd2.usage).thenReturn(_mockUsageOutput);
  when(() => cmd2.description).thenReturn(_mockCommandDescription2);
  when(() => cmd2.subcommands).thenReturn({});

  when(() => cmd1.subcommands).thenReturn({cmd2.name: cmd2});
  return cmd1;
}

void main() {
  group('HelpModelParserFromCommandRunner', () {
    test(
      'correctly parses '
      'command output',
      () {
        final cmd = _buildMockCommand();
        final model = HelpModelParserFromCommand(
          parents: '',
          command: cmd,
        ).parseModel(parseChildren: false);

        expect(model.commandName, equals(_mockCommandName1));
        expect(model.parents, isEmpty);
        expect(model.description, equals([_mockCommandDescription1]));
        expect(model.entireHelpOutput, equals(_mockUsageOutput));
        expect(
          model.childCommands,
          equals([
            _mockCommandName2,
          ]),
        );
      },
    );
    test(
      'correctly parses '
      'child command',
      () {
        final cmd = _buildMockCommand();
        final model = HelpModelParserFromCommand(
          parents: '',
          command: cmd,
        ).parseModel();

        expect(model.commandName, equals(_mockCommandName1));
        expect(model.parents, isEmpty);
        expect(model.description, equals([_mockCommandDescription1]));
        expect(model.entireHelpOutput, equals(_mockUsageOutput));
        expect(
          model.childCommands,
          equals([
            _mockCommandName2,
          ]),
        );
        expect(model.childCommandModels.first.entireHelpOutput, _mockUsageOutput);
      },
    );
  });
}
