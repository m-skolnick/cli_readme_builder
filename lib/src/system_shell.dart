import 'package:process_run/shell.dart';

class SystemShell {
  SystemShell._();

  static Future<String> run(String command) async {
    final output = await Shell(
      commandVerbose: true,
      commentVerbose: true,
    ).run(command);

    return output.outText;
  }
}
