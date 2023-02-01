import 'dart:io';
import 'package:path/path.dart' as p;

class ExecutableFinder {
  static String getExecutablePath() {
    final binDir = p.join(Directory.current.path, 'bin');

    final executableDirs = Directory(binDir).listSync();
    if (executableDirs.isNotEmpty && executableDirs.length == 1) {
      print('executable path is: ${executableDirs.first.path}');
      return executableDirs.first.path;
    }

    throw const FileSystemException('Executable not found bin directory');
  }
}
