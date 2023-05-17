import 'package:mason_logger/mason_logger.dart';
import 'package:process_run/shell.dart';

import '../readme_builder.dart';

class SystemShell {
  SystemShell();

  Future<String> run(String command) async {
    final output = await Shell(
      verbose: logger.level == Level.verbose,
      commandVerbose: logger.level == Level.verbose,
      commentVerbose: logger.level == Level.verbose,
    ).run(command);

    return output.outText;
  }
}
