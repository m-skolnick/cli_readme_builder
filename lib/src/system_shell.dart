import 'package:process_run/shell.dart';

class SystemShell {
  SystemShell._();

  static Future<String> run(String command) async {
    final output = await Shell(
      verbose: false,
      commandVerbose: false,
      commentVerbose: false,
    ).run(command);

    return output.outText;
  }
}
