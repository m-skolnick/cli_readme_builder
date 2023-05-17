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
import 'package:mason_logger/mason_logger.dart';

import 'src/executable_finder.dart';
import 'src/help_model/help_model_parser_from_string.dart';
import 'src/help_model/help_model_string_builder.dart';
import 'src/system_shell.dart';

final logger = Logger();

Builder cliReadmeBuilder([BuilderOptions? options]) => _ReadmeBuilder(
      options?.config['output'] as String,
      options?.config['verbose_logging'] as bool,
    );

class _ReadmeBuilder implements Builder {
  final String output;
  final bool verboseLogging;

  _ReadmeBuilder(this.output, this.verboseLogging) {
    if (verboseLogging) {
      logger
        ..level = Level.verbose
        ..info('LOGGING AT A VERBOSE LEVEL');
    }
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final executablePath = ExecutableFinder.getExecutablePath();

    final topLevelOutput = await SystemShell().run('dart run $executablePath --help');

    final topLevelHelpModel = await HelpModelParserFromString(
      executablePath: executablePath,
      parents: '',
      output: topLevelOutput,
    ).parseModel();

    final output = HelpModelStringBuilder.getFullOutput(topLevelHelpModel);

    await buildStep.writeAsString(
      buildStep.allowedOutputs.single,
      output,
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        'pubspec.yaml': [output],
      };
}
