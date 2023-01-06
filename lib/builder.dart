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

    await buildStep.writeAsString(
      buildStep.allowedOutputs.single,
      '''
# ${topLevelHelpModel.description.join('\n')}

## Usage

${topLevelHelpModel.toOutput()}

## Available commands

${_getAvailableCommands(topLevelHelpModel)}
''',
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        'pubspec.yaml': [output],
      };
}

String _getAvailableCommands(HelpOutputModel model) {
  final lines = <String>[];
  for (var command in model.subCommandOutput) {
    lines.add('* [${command.commandName}](#${command.commandName})');
  }
  return lines.join('\n');
}
