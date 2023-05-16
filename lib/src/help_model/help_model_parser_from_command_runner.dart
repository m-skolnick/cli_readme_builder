import 'package:args/command_runner.dart';

import '../system_shell.dart';
import 'help_model.dart';

/// Parse output directly from command runner
///
class HelpModelParserFromCommand {
  final String parents;
  final Command command;
  final List<String> outputLines;
  final String output;
  final bool recursive;

  HelpModelParserFromCommand({
    required this.command,
    required this.output,
    required this.parents,
    this.recursive = true,
  }) : outputLines = output.split('\n');

  Future<HelpModel> parseModel() async => HelpModel(
        description: command.description.split('\n'),
        entireHelpOutput: command.usage,
        parents: parents,
        commandName: command.name,
        childCommands: command.subcommands.keys.toList(),
        childCommandModels: await getSubCommandsOutput(),
      );

  String getCommandName() {
    String commandName;

    final usage = outputLines
        .getRange(
          usageStart,
          usageEnd,
        )
        .toList();

    if (parents.isEmpty) {
      // set executable name
      final usageLine = usage.first;
      const usageString = 'Usage: ';
      final startOfName = usageLine.indexOf(usageString) + usageString.length;
      final endOfName = usageLine.indexOf(' <command>');
      commandName = usageLine.substring(startOfName, endOfName);
    } else {
      // set command name
      final usageLine = usage.first;
      final startOfName = usageLine.indexOf(parents) + parents.length + 1;
      var endOfName = usageLine.indexOf(' <subcommand>');
      if (endOfName == -1) {
        endOfName = usageLine.indexOf(' [arguments]');
      }
      commandName = usageLine.substring(startOfName, endOfName);
    }

    return commandName;
  }

  Future<List<HelpModel>> getSubCommandsOutput() async {
    final subCommandsOutput = <HelpModel>[];

    if (recursive) {
      final commandList = getCommandList();
      final commandName = getCommandName();

      final parentsWithoutCliName = parents.split(' ').skip(1).join(' ');
      final childCommandModelFutures = <Future<HelpModel>>[];

      for (var childCommand in commandList) {
        final commandChain = [
          executablePath,
          parentsWithoutCliName,
          if (parents.isNotEmpty) commandName,
          childCommand,
        ].where((e) => e.trim().isNotEmpty).join(' ').trim();

        final childCommandModel = _getChildCommandModel(
          commandOutputFuture: SystemShell.run('dart run $commandChain --help'),
          commandName: commandName,
        );
        childCommandModelFutures.add(childCommandModel);
      }

      final childCommandModels = await Future.wait(childCommandModelFutures);
      subCommandsOutput.addAll(childCommandModels);
    }

    return subCommandsOutput;
  }

  Future<HelpModel> _getChildCommandModel({
    required Future<String> commandOutputFuture,
    required String commandName,
  }) async {
    final output = await commandOutputFuture;

    final childModel = await HelpModelParserFromCommand(
      commandRunner: commandRunner,
      parents: [parents, commandName].where((e) => e.trim().isNotEmpty).join(' '),
      output: output,
    ).parseModel();

    return childModel;
  }
}
