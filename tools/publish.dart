import 'package:process_run/shell.dart';

// Used to quickly publish this package.
// Soon this will be moved to a github action which runs on [main]
Future<void> main(List<String> args) async {
  final newVersion = args.first;
  await Shell().run('gh release create $newVersion --notes "bugfix release"');
  await Shell().run('dart pub publish');
}
