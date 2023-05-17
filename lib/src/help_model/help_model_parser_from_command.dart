// ignore_for_file: strict_raw_type

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

import 'help_model.dart';

/// Parse output from command
@visibleForTesting
class HelpModelParserFromCommand {
  final String parents;
  final Command command;
  late final Iterable<Command> _filteredChildren;

  HelpModelParserFromCommand({
    required this.command,
    required this.parents,
  }) {
    _filteredChildren = command.subcommands.values.where((e) => !e.hidden);
  }

  HelpModel parseModel({bool parseChildren = true}) => HelpModel(
        description: command.description.split('\n'),
        entireHelpOutput: command.usage,
        parents: parents,
        commandName: command.name,
        childCommands: _filteredChildren.map((e) => e.name).toList(),
        childCommandModels: parseChildren ? getChildCommandModels() : [],
      );

  @visibleForTesting
  List<HelpModel> getChildCommandModels() {
    final childCommandModels = <HelpModel>[];

    for (final child in _filteredChildren) {
      childCommandModels.add(
        HelpModelParserFromCommand(
          command: child,
          parents: [parents, command.name].join(' '),
        ).parseModel(),
      );
    }

    return childCommandModels;
  }
}
