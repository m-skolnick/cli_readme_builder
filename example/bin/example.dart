import 'package:example/example_cli_command_runner.dart';

Future<void> main(List<String> arguments) async {
  await ExampleCliCommandRunner().run(arguments);
}
