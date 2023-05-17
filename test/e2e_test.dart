import 'dart:io';

import 'package:cli_readme_builder/readme_builder.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:test/test.dart';

void main() {
  test(
    'when using build_runner '
    'correctly builds example app readme',
    () async {
      final result = await Shell(
        workingDirectory: p.join(Directory.current.path, 'example'),
        throwOnError: false,
        verbose: false,
      ).run(
        'dart run build_runner build --delete-conflicting-outputs',
      );

      if (result.first.exitCode != 0) {
        logger.err(result.errText);
      }

      expect(result.first.exitCode, equals(0));
      final outputFile = File(p.join(Directory.current.path, 'example', 'example_output_file_from_build_runner.md'));
      final desiredOutputFile = File(p.join(Directory.current.path, 'example', 'desired_output.md'));

      final outputFileLines = outputFile.readAsStringSync();
      final desiredOutputFileLines = desiredOutputFile.readAsStringSync();

      expect(outputFileLines, desiredOutputFileLines);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
  test(
    'when using dart executable '
    'correctly builds example app readme',
    () async {
      final result = await Shell(
        workingDirectory: p.join(Directory.current.path, 'example'),
        throwOnError: false,
        verbose: false,
      ).run(
        'dart run example_from_executable/build_from_executable.dart',
      );

      if (result.first.exitCode != 0) {
        logger.err(result.errText);
      }

      expect(result.first.exitCode, equals(0));
      final outputFile = File(p.join(Directory.current.path, 'example', 'example_output_file_from_executable.md'));
      final desiredOutputFile = File(p.join(Directory.current.path, 'example', 'desired_output.md'));

      final outputFileLines = outputFile.readAsStringSync();
      final desiredOutputFileLines = desiredOutputFile.readAsStringSync();

      expect(outputFileLines, desiredOutputFileLines);
    },
  );
}
