@Tags(['presubmit-only'])
import 'package:build_verify/build_verify.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Ensure git status is clean and build_runner completes successfully',
    expectBuildClean,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
