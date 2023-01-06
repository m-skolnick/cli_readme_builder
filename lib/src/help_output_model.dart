class HelpOutputModel {
  /// The name of the parent CLI (eg.. build_runner)
  final String cliExecutableName;

  /// Description of command (ie.. help)
  final List<String> description;

  /// Entire help output (ie.. all the output to console when <command> --help is ran)
  final String entireHelpOutput;

  /// Name of command
  final List<String> name;

  /// A list of all sub commands parsed from help output
  /// This is used to execute and capture the help outputs for each sub-command
  final List<String> subCommands;

  /// Parsed help output from each sub command
  final List<HelpOutputModel> subCommandOutput;

  /// Usage
  final List<String> usage;

  HelpOutputModel._({
    required this.cliExecutableName,
    required this.description,
    required this.entireHelpOutput,
    required this.name,
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
  static HelpOutputModel fromHelpOutput({
    required String output,
    String? cliExecutableName,
  }) {
    final outputLines = output.split('/n');

    const descriptionStart = 0;
    final usageStart = outputLines.indexWhere((e) => e.contains('Usage: ') && e.contains('[arguments]'));
    final commandsListStart =
        outputLines.indexWhere((e) => e.contains('Available commands:') || e.contains('Available subcommands:'));
    final helpPromptStart = outputLines.indexWhere((e) => e.contains('Run') && e.contains('help'));

    final descriptionEnd = usageStart - 2;
    final usageEnd = commandsListStart - 2;
    final commandsListEnd = helpPromptStart - 2;
    final helpPromptEnd = outputLines.length;

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
        .toList();

    final helpPrompt = outputLines
        .getRange(
          helpPromptStart,
          helpPromptEnd,
        )
        .toList();

    final String executableName;
    if (cliExecutableName == null) {
      final usageLine = usage.first;
      const usageString = 'Usage: ';
      final startOfName = usageLine.indexOf(usageString) + usageString.length + 1;
      final endOfName = usageLine.indexOf(' <command>');
      executableName = usageLine.substring(startOfName, endOfName);
    } else {
      executableName = cliExecutableName;
    }
    return HelpOutputModel._(
      cliExecutableName: executableName,
      description: description,
      entireHelpOutput: output,
      name: [],
      subCommands: [],
      subCommandOutput: [],
      usage: usage,
    );
  }
}
