import 'package:args/command_runner.dart';
import 'package:example/command_1.dart';
import 'package:example/command_2.dart';

class ExampleCliCommandRunner extends CommandRunner<int> {
  ExampleCliCommandRunner() : super('example_cli', 'Example CLI app') {
    addCommand(Command1());
    addCommand(Command2());
  }
}
