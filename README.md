<h1 align="center">CLI README Builder</h1>
<br/>

<p align="center">
<a href="https://github.com/m-skolnick/cli_readme_builder/actions/workflows/build.yaml"><img src="https://github.com/m-skolnick/cli_readme_builder/actions/workflows/build.yaml/badge.svg" alt="build status"></a>
<a href="https://codecov.io/gh/m-skolnick/cli_readme_builder"><img src="https://codecov.io/gh/m-skolnick/cli_readme_builder/branch/main/graph/badge.svg" alt="codecov"></a>
<a href="https://pub.dev/packages/cli_readme_builder"><img src="https://img.shields.io/pub/v/cli_readme_builder.svg" alt="Latest version on pub.dev"></a>
</p>

---
<br/>

<p align="center">A builder to generate a README </p>

## Overview

The goal of this package is to automate the process of creating a readme file for Dart console applications.

### How it Works

This package generates a single file which contains `--help` output from every command in the application.

This builder works as follows:
1. Find the binary executable file in your package
1. Run the executable with the `--help` flag
1. Capture the output and parse it
1. For each top-level command, capture the `--help` output of that command and its sub-commands
1. Generate a file with the information gathered above

## Usage
1. Add `cli_readme_builder` and `build_runner` to `pubspec.yaml`

    ```yaml
    name: example_cli
    dev_dependencies:
      build_runner: ^1.0.0
      cli_readme_builder: ^1.0.0
    ```

1. Run a build

    ```console
    > dart pub run build_runner build
    ```

1. `README.g.md` will be generated with content:
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

See a full example output here: [Example App Output][example_app_output]

## Customization

To change the path of the generated file, create a [`build.yaml`][build_config]
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

## Advanced

### Verbose logging

In an effort to make debugging easier, `verbose_logging` can be added as an input to the `build.yaml`

```yaml
targets:
  $default:
    builders:
      cli_readme_builder:
        options:
          verbose_logging: true
```

## Maintainers

- [Micaiah Skolnick](https://github.com/m-skolnick)

[build_config]: https://pub.dev/packages/build_config
[example_app_output]: https://github.com/m-skolnick/cli_readme_builder/blob/main/example/my_output_file.md