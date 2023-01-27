import 'package:process_run/shell.dart';

// Used to quickly publish this package.
// Soon this will be moved to a github action which runs on [main]

// example usage
// dart run tool/publish.dart v1.0.4
Future<void> main(List<String> args) async {
  final newVersion = args.first;

  final dryRunResult = await Shell().run('dart pub publish --dry-run');
  if (dryRunResult.first.exitCode != 0) {
    return;
  }
  // If the changelog doesn't contain the current version, this will be a warning in
  // the publish output
  if (dryRunResult.outText.contains('mention current version')) {
    return;
  }

  final publishResult = await Shell().run('dart pub publish -f');
  if (publishResult.first.exitCode != 0) {
    return;
  }

  await Shell().run('gh release create $newVersion --notes "$newVersion"');
}
