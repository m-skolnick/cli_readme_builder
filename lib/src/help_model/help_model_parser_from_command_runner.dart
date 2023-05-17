// ignore_for_file: strict_raw_type

import 'package:args/command_runner.dart';
import 'help_model.dart';
import 'help_model_parser_from_command.dart';

/// Parse output from command runner
class HelpModelParserFromCommandRunner {
  final CommandRunner commandRunner;
  late final Iterable<Command> _filteredChildren;

  HelpModelParserFromCommandRunner({
    required this.commandRunner,
  }) {
    _filteredChildren = commandRunner.commands.values.where((e) => !e.hidden);
  }

  HelpModel parseModel({bool parseChildren = true}) => HelpModel(
        description: commandRunner.description.split('\n'),
        entireHelpOutput: commandRunner.usage,
        parents: '',
        commandName: commandRunner.executableName,
        childCommands: _filteredChildren.map((e) => e.name).toList(),
        childCommandModels: parseChildren ? getSubCommandsOutput() : [],
      );

  List<HelpModel> getSubCommandsOutput() {
    final childCommandModels = <HelpModel>[];

    for (final child in _filteredChildren) {
      childCommandModels.add(
        HelpModelParserFromCommand(
          command: child,
          parents: commandRunner.executableName,
        ).parseModel(),
      );
    }

    return childCommandModels;
  }
}
