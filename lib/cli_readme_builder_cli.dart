import 'package:args/command_runner.dart';

/// This class should be used in place of running build_runner
/// Instructions for adding this to a dart executable file:
///   1. Add cli_readme_builder to dev dependencies
///   2. Create a dart file with the following contents:
/// ```dart
/// void main(List<String> args) {
///   final myCommandRunner = MyCommandRunner()
///   ReadmeBuilderCli(args, myCommandRunner).generateReadme()
/// }
/// ```
///   3. Run the dart file
/// ```shell
/// dart run <path to my dart file>
/// ```
///   4. You should now have a file generated with your output file
class ReadmeBuilderCli {
  final CommandRunner commandRunner;

  ReadmeBuilderCli(this.commandRunner);
}
