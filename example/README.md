A simple command-line application which demonstrates how to use [cli_readme_builder](https://github.com/m-skolnick/cli_readme_builder.git)

Notice the following:

1. [example_cli_command_runner](https://github.com/m-skolnick/cli_readme_builder/blob/main/example/lib/example_cli_command_runner.dart)
    > This is a simple command line application using the default Dart [Command Runner](https://pub.dev/documentation/args/latest/command_runner/CommandRunner-class.html)
1. [pubspec.yaml](https://github.com/m-skolnick/cli_readme_builder/blob/main/example/pubspec.yaml) 
    > Contains `cli_readme_builder` and `build_runner`
1. [build.yaml](https://github.com/m-skolnick/cli_readme_builder/blob/main/example/build.yaml)
    > Overrides the default output file 
1. [my_output_file.md](https://github.com/m-skolnick/cli_readme_builder/blob/main/example/my_output_file.md)
    >This is the generated output readme file
    >
    >To generate this file, run build_runner:
    >
    >```
    >dart run build_runner build --delete-conflicting-outputs
    >```
    