import 'package:args/command_runner.dart';

class LeafCommand extends Command<int> {
  @override
  String get description => 'Leaf Command description';

  @override
  String get name => 'leaf_command';
}

class LeafCommandWithInput extends Command<int> {
  LeafCommandWithInput() {
    argParser.addOption(
      'option_arg',
      valueHelp: 'value help for option',
      help: 'An option argument',
    );
    argParser.addFlag(
      'flag_arg',
      help: 'A flag argument',
    );
  }

  @override
  String get description => 'Leaf Command description';

  @override
  String get name => 'leaf_command_with_input';
}

class BranchCommand extends Command<int> {
  BranchCommand() {
    addSubcommand(LeafCommand());
    addSubcommand(ChildBranchCommand());
  }
  @override
  String get description => 'Branch Command description';

  @override
  String get name => 'branch_command';
}

class ChildBranchCommand extends Command<int> {
  ChildBranchCommand() {
    addSubcommand(LeafCommand());
  }
  @override
  String get description => 'Child Branch Command description';

  @override
  String get name => 'child_branch_command';
}
