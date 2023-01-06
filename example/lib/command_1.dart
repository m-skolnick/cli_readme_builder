import 'package:args/command_runner.dart';

class Command1 extends Command<int> {
  @override
  String get description => 'command 1 description';

  @override
  String get name => 'command_1';
}
