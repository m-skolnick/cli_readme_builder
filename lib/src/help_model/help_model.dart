class HelpModel {
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
  final List<HelpModel> subCommandOutput;

  HelpModel({
    required this.commandName,
    required this.description,
    required this.entireHelpOutput,
    required this.parents,
    required this.subCommands,
    required this.subCommandOutput,
  });
}
