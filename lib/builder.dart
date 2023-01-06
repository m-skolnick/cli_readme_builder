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
import 'package:pubspec_parse/pubspec_parse.dart';

import 'src/executable_finder.dart';
import 'src/help_output_model.dart';
import 'src/system_shell.dart';

const _defaultOutput = 'README.md';

Builder cliReadmeBuilder([BuilderOptions? options]) =>
    _ReadmeBuilder((options?.config['output'] as String?) ?? _defaultOutput);

class _ReadmeBuilder implements Builder {
  final String output;

  _ReadmeBuilder(this.output);

  @override
  Future<void> build(BuildStep buildStep) async {
    final executablePath = ExecutableFinder.getExecutablePath();

    final topLevelOutput = await SystemShell.run('dart run $executablePath --help');

    final topLevelHelpModel = await HelpOutputModel.fromHelpOutput(
      output: topLevelOutput,
      executablePath: executablePath,
      parents: '',
    );

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
$topLevelOutput
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
