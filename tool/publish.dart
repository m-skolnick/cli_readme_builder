import 'package:process_run/shell.dart';

// Used to release this package.
// Use this file to create a release
//     -> release triggers tag creation
//          -> triggers a GH action to upload code coverage

// example usage
// dart run tool/publish.dart v1.0.4
Future<void> main(List<String> args) async {
  final newVersion = args.first;

  final dryRunResult = await Shell(
    throwOnError: false,
  ).run('dart pub publish --dry-run');
  if (dryRunResult.first.exitCode != 0) {
    print('PUBLISH FAILED AT DRY RUN');
    return;
  }

  final publishResult = await Shell().run('dart pub publish -f');
  if (publishResult.first.exitCode != 0) {
    print('PUBLISH FAILED AT PUBLISH');
    return;
  }

  await Shell().run('gh release create $newVersion --notes "$newVersion"');
}
