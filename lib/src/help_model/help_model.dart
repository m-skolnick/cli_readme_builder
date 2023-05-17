class HelpModel extends Comparable<HelpModel> {
  /// Name of command
  final String? commandName;

  /// Description of command (ie.. help)
  final List<String> description;

  /// Entire help output (ie.. all the output to console when <command> --help is ran)
  final String entireHelpOutput;

  /// Concatenated parents of this command
  /// In essence this is the chain of commands to get to this command
  /// eg: for the child of a leaf command, the parents would be: 'test_cli leaf_command'
  final String parents;

  /// A list of all sub commands parsed from help output
  /// When parsing from help output string, this is used to execute and capture the help outputs for each sub-command
  final List<String> childCommands;

  /// Parsed help output from each sub command
  final List<HelpModel> childCommandModels;

  HelpModel({
    required this.commandName,
    required this.description,
    required this.entireHelpOutput,
    required this.parents,
    required this.childCommands,
    required this.childCommandModels,
  });

  @override
  int compareTo(HelpModel other) {
    if (commandName != null) {
      return commandName!.compareTo(other.commandName ?? '');
    }
    return parents.compareTo(other.parents);
  }
}
