import 'system_shell.dart';

class HelpOutputModel {
  /// Name of command
  final String? commandName;

  /// Description of command (ie.. help)
  final List<String> description;

  /// Entire help output (ie.. all the output to console when <command> --help is ran)
  final String entireHelpOutput;

  /// Concatenated parents of this command
  /// eg: for the child of a leaf command, the parents would be: 'test_cli leaf_command'
  final String parents;

  /// A list of all sub commands parsed from help output
  /// This is used to execute and capture the help outputs for each sub-command
  final List<String> subCommands;

  /// Parsed help output from each sub command
  final List<HelpOutputModel> subCommandOutput;

  HelpOutputModel({
    required this.commandName,
    required this.description,
    required this.entireHelpOutput,
    required this.parents,
    required this.subCommands,
    required this.subCommandOutput,
  });

  /// Parse from output
  ///
/* Top Level Output
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

/* Branch Command Output
Branch Command description

Usage: example_cli branch_command <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  child_branch_command   Child Branch Command description
  leaf_command           Leaf Command description

Run "example_cli help" to see global options.
*/
  static Future<HelpOutputModel> fromHelpOutput({
    required String output,
    required String executablePath,
    required String parents,
    bool recursive = true,
  }) async {
    final outputLines = output.split('\n');

    late int descriptionStart;
    late int usageStart;
    late int commandsListSectionStart;
    late int commandsListStart;
    late int helpPromptStart;

    void setSectionStarts() {
      descriptionStart = 0;
      usageStart = outputLines.indexWhere((e) => e.contains('Usage: ') && e.contains('[arguments]'));
      commandsListSectionStart =
          outputLines.indexWhere((e) => e.contains('Available commands:') || e.contains('Available subcommands:'));
      commandsListStart = commandsListSectionStart + 1;
      helpPromptStart = outputLines.indexWhere((e) => e.contains('Run') && e.contains('help'));
    }

    late int descriptionEnd;
    late int usageEnd;
    late int commandsListEnd;

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

    Future<List<HelpOutputModel>> getSubCommandsOutput() async {
      final subCommandsOutput = <HelpOutputModel>[];

      if (recursive) {
        final commandList = getCommandList();
        final commandName = getCommandName();

        final parentsWithoutCliName = parents.split(' ').skip(1).join(' ');

        for (var childCommand in commandList) {
          final commandChain = [
            executablePath,
            parentsWithoutCliName,
            if (parents.isNotEmpty) commandName,
            childCommand,
          ].where((e) => e.trim().isNotEmpty).join(' ').trim();
          print(commandChain);
          final commandOutput = await SystemShell.run('dart run $commandChain --help');
          subCommandsOutput.add(
            await HelpOutputModel.fromHelpOutput(
              output: commandOutput,
              executablePath: executablePath,
              parents: [parents, commandName].where((e) => e.trim().isNotEmpty).join(' '),
            ),
          );
        }
      }

      return subCommandsOutput;
    }

    setSectionStarts();
    setSectionEnds();

    return HelpOutputModel(
      description: getDescription(),
      entireHelpOutput: output,
      parents: parents,
      commandName: getCommandName(),
      subCommands: getCommandList(),
      subCommandOutput: await getSubCommandsOutput(),
    );
  }

  String toOutput() => '''
```sh
$parents $commandName --help
```

Help output:

```
$entireHelpOutput
```
''';
}
