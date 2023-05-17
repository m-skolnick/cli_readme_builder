import 'package:cli_readme_builder/readme_builder_from_command_runner.dart';
import 'package:example/example_cli_command_runner.dart';

void main(List<String> args) {
  final myCommandRunner = ExampleCliCommandRunner();
  final argsOverride = ['--output', 'example_output_file_from_cli.md'];
  ReadmeBuilderFromCommandRunner(
    argsOverride,
    myCommandRunner,
  ).generateReadme();
}
