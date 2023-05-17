// ignore_for_file: strict_raw_type

import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'src/help_model/help_model_parser_from_command_runner.dart';
import 'src/help_model/help_model_string_builder.dart';

/// This class should be used in place of running build_runner
/// See instructions in README.md
class ReadmeBuilderFromCommandRunner extends CommandRunner<int> {
  late final ArgResults _argResults;
  final CommandRunner _commandRunner;

  ReadmeBuilderFromCommandRunner(List<String> args, this._commandRunner)
      : super('readme_builder_from_command_runner', 'A tool to compile help output from an entire Dart CLI') {
    argParser.addOption(
      'output',
      defaultsTo: 'README.g.md',
    );
    _argResults = parse(args);
  }

  void generateReadme() {
    final outputFilePath = _argResults['output'] as String;
    final topLevelHelpModel = HelpModelParserFromCommandRunner(commandRunner: _commandRunner).parseModel();
    final output = HelpModelStringBuilder.getFullOutput(topLevelHelpModel);
    File(outputFilePath).writeAsStringSync(output);
  }
}
