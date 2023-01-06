class HelpOutputModel {
  /// Description of command (ie.. help)
  final List<String> description;

  /// Entire help output (ie.. all the output to console when <command> --help is ran)
  final String entireHelpOutput;

  /// Name of command
  final String? commandName;

  /// Concatenated parents of this command
  /// eg: for the child of a leaf command, the parents would be: 'test_cli leaf_command'
  final String parents;

  /// A list of all sub commands parsed from help output
  /// This is used to execute and capture the help outputs for each sub-command
  final List<String> subCommands;

  /// Parsed help output from each sub command
  final List<HelpOutputModel> subCommandOutput;

  /// Usage
  final List<String> usage;

  HelpOutputModel._({
    required this.description,
    required this.entireHelpOutput,
    required this.commandName,
    required this.parents,
    required this.subCommands,
    required this.subCommandOutput,
    required this.usage,
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
    bool isTopLevel = false,
    bool recursive = true,
  }) async {
    final outputLines = output.split('\n');

    const descriptionStart = 0;
    final usageStart = outputLines.indexWhere((e) => e.contains('Usage: ') && e.contains('[arguments]'));
    final commandsListSectionStart =
        outputLines.indexWhere((e) => e.contains('Available commands:') || e.contains('Available subcommands:'));
    final commandsListStart = commandsListSectionStart + 1;
    final helpPromptStart = outputLines.indexWhere((e) => e.contains('Run') && e.contains('help'));

    final descriptionEnd = usageStart - 1;
    final usageEnd = commandsListSectionStart - 1;
    final commandsListEnd = helpPromptStart - 1;

    final description = outputLines
        .getRange(
          descriptionStart,
          descriptionEnd,
        )
        .toList();

    final usage = outputLines
        .getRange(
          usageStart,
          usageEnd,
        )
        .toList();

    final commandList = outputLines
        .getRange(
      commandsListStart,
      commandsListEnd,
    )
        .map((e) {
      final trimmed = e.trimLeft();
      final commandNameEnd = trimmed.indexOf(' ');
      return trimmed.substring(0, commandNameEnd);
    }).toList();

    String commandName;
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
      final startOfName = usageLine.indexOf(parents) + parents.length;
      var endOfName = usageLine.indexOf(' <subcommand>');
      if (endOfName == -1) {
        endOfName = usageLine.indexOf(' [arguments]');
      }
      commandName = usageLine.substring(startOfName, endOfName);
    }

    final subCommandOutput = [];
    if (recursive) {
      // for (var command in commandList) {
      //   final commandChain = [executablePath, commandName].join(' ');
      //   final commandOutput = await SystemShell.run('dart run $commandChain --help');

      //   await HelpOutputModel.fromHelpOutput(
      //     output: commandOutput,
      //     executablePath: executablePath,
      //     // parents: parents + commandName;
      //   );
      // }
    }

    return HelpOutputModel._(
      description: description,
      entireHelpOutput: output,
      parents: parents,
      commandName: commandName,
      subCommands: commandList,
      subCommandOutput: [],
      usage: usage,
    );
  }
}
