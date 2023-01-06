import 'package:args/command_runner.dart';
import 'package:example/commands.dart';

class ExampleCliCommandRunner extends CommandRunner<int> {
  ExampleCliCommandRunner() : super('example_cli', 'Example CLI app') {
    addCommand(LeafCommand());
    addCommand(LeafCommandWithInput());
    addCommand(BranchCommand());
  }
}
