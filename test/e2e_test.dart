import 'dart:io';

import 'package:cli_readme_builder/cli_readme_builder.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:test/test.dart';

void main() {
  test(
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
      final outputFile = File(p.join(Directory.current.path, 'example', 'my_output_file.md'));
      final desiredOutputFile = File(p.join(Directory.current.path, 'example', 'desired_output.md'));

      final outputFileLines = outputFile.readAsStringSync();
      final desiredOutputFileLines = desiredOutputFile.readAsStringSync();

      expect(outputFileLines, desiredOutputFileLines);
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
