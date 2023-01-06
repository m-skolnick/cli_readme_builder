import 'package:args/command_runner.dart';

class Command2 extends Command<int> {
  @override
  String get description => 'command 2 description';

  @override
  String get name => 'command_2';
}
