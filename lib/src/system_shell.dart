import '../cli_readme_builder.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/shell.dart';

class SystemShell {
  SystemShell._();

  static Future<String> run(String command) async {
    final output = await Shell(
      commandVerbose: logger.level == Level.verbose,
      commentVerbose: logger.level == Level.verbose,
    ).run(command);

    return output.outText;
  }
}
