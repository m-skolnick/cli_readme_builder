/// Configuration for using `package:build`-compatible build systems.
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline.
///
/// See [package:build_runner](https://pub.dev/packages/build_runner)
/// for more information.
library builder;

import 'dart:async';

import 'package:build/build.dart';
import 'package:process_run/shell.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

const _defaultOutput = 'README.md';

Builder cliReadmeBuilder([BuilderOptions? options]) =>
    _VersionBuilder((options?.config['output'] as String?) ?? _defaultOutput);

class _VersionBuilder implements Builder {
  final String output;

  _VersionBuilder(this.output);

  @override
  Future<void> build(BuildStep buildStep) async {
    final output = await Shell(
      verbose: false,
      commandVerbose: false,
      commentVerbose: false,
    ).run('dart run');
    final initialOutput = output.first.outText;

    final assetId = AssetId(buildStep.inputId.package, 'pubspec.yaml');

    if (assetId != buildStep.inputId) {
      // Skip nested packages!
      // Should be able to use `^pubspec.yaml` – but it does not work
      // See https://github.com/dart-lang/build/issues/3286
      return;
    }

    final content = await buildStep.readAsString(assetId);

    final pubspec = Pubspec.parse(content, sourceUrl: assetId.uri);

    if (pubspec.version == null) {
      throw StateError('pubspec.yaml does not have a version defined.');
    }

    await buildStep.writeAsString(
      buildStep.allowedOutputs.single,
      '''
$initialOutput
// Generated code. Do not modify.
const packageVersion = '${pubspec.version}';
''',
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        'pubspec.yaml': [output],
      };
}
