import '../system_shell.dart';
import 'help_model.dart';

/// Parse from output
///
/* Example Top Level Output
Example CLI app

Usage: example_cli <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  branch_command            Branch Command description
  leaf_command              Leaf Command description
  leaf_command_with_input   Leaf Command description

Run "example_cli help <command>" for more information about a command.
*/

/* Example Branch Command Output
Branch Command description

Usage: example_cli branch_command <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  child_branch_command   Child Branch Command description
  leaf_command           Leaf Command description

Run "example_cli help" to see global options.
*/
class HelpModelParserFromString {
  final String parents;
  final String executablePath;
  final bool recursive;
  final List<String> outputLines;
  final String output;

  HelpModelParserFromString({
    required this.executablePath,
    required this.output,
    required this.parents,
    this.recursive = true,
  }) : outputLines = output.split('\n');

  late int descriptionStart;
  late int usageStart;
  late int commandsListSectionStart;
  late int commandsListStart;
  late int helpPromptStart;

  late int descriptionEnd;
  late int usageEnd;
  late int commandsListEnd;

  Future<HelpModel> parseModel() async {
    setSectionStarts();
    setSectionEnds();

    return HelpModel(
      description: getDescription(),
      entireHelpOutput: output,
      parents: parents,
      commandName: getCommandName(),
      childCommands: getCommandList(),
      childCommandModels: await getSubCommandsOutput(),
    );
  }

  void setSectionStarts() {
    descriptionStart = 0;
    usageStart = outputLines.indexWhere((e) => e.contains('Usage: ') && e.contains('[arguments]'));
    commandsListSectionStart = outputLines.indexWhere(
      (e) => e.contains('Available commands:') || e.contains('Available subcommands:'),
    );
    commandsListStart = commandsListSectionStart + 1;
    helpPromptStart = outputLines.indexWhere((e) => e.contains('Run') && e.contains('help'));
  }

  void setSectionEnds() {
    descriptionEnd = usageStart - 1;
    usageEnd = commandsListSectionStart - 1;
    if (commandsListSectionStart == -1) {
      usageEnd = helpPromptStart - 1;
    }
    commandsListEnd = helpPromptStart - 1;
  }

  List<String> getDescription() => outputLines
      .getRange(
        descriptionStart,
        descriptionEnd,
      )
      .toList();

  List<String> getCommandList() {
    if (commandsListSectionStart == -1) {
      return [];
    }

    return outputLines
        .getRange(
      commandsListStart,
      commandsListEnd,
    )
        .map((e) {
      final trimmed = e.trimLeft();
      final commandNameEnd = trimmed.indexOf(' ');
      return trimmed.substring(0, commandNameEnd);
    }).toList();
  }

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

    final childModel = await HelpModelParserFromString(
      executablePath: executablePath,
      parents: [parents, commandName].where((e) => e.trim().isNotEmpty).join(' '),
      output: output,
    ).parseModel();

    return childModel;
  }
}
