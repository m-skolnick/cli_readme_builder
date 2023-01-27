## Overview

The goal of this package is to automate the process of creating a readme file for Dart console applications.

### How it Works

This package generates a single file which contains --help output from every command in the application.

This builder works as follows:
1. Find the binary executable file in your package
1. Run the executable with the `--help` flag
1. Capture the output and parse it
1. For each command in the help output, capture the `--help` output of that command and it's sub-commands
1. Generate a file with the information gathered above

## Usage
Include the version of your package in our source code.

1. Add `cli_readme_builder` to `pubspec.yaml`. Also make sure there is a `version`
   field.

    ```yaml
    name: my_pkg
    version: 1.2.3
    dev_dependencies:
      build_runner: ^1.0.0
      cli_readme_builder: ^1.0.0
    ```

2. Run a build.

    ```console
    > dart pub run build_runner build
    ```

    `README.g.md` will be generated with content:

># example_cli
>
>Example CLI app
>
>## Usage
>
>```sh
>example_cli --help
>```
>
>Help output:
>
>```
>Example CLI app
>
>Usage: example_cli <command> [arguments]
>
>Global options:
>-h, --help    Print this usage information.
>
>Available commands:
  >child_command              Child Command description
>
>Run "example_cli help <command>" for more information about a command.
>```
>
>## Available commands
>
>* [child_command](#child_command)
>
>### child_command
>
>```sh
>example_cli child_command --help
>```
>
>Help output:
>
>```
>Child Command description
>
>Usage: example_cli child_command [arguments]
> -h, --help                                  Print this usage information.
>    --option_arg=<value help for option>    An option argument
>    --[no-]flag_arg                         A flag argument
>
>Run "example_cli help" to see global options.
>```

See a full example output here: [Example App Output](https://github.com/m-skolnick/cli_readme_builder/blob/main/example/my_output_file.md)

## Customization

To change the path of the generated file, create a [`build.yaml`](build config)
in the root of your package.
By changing the `output` option of this builder, the path can be customized:

```yaml
targets:
  $default:
    builders:
      cli_readme_builder:
        options:
          output: my_output_file.md
```
