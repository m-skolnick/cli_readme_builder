[![CI](https://github.com/m-skolnick/cli_readme_builder/workflows/CI/badge.svg?branch=master)](https://github.com/m-skolnick/cli_readme_builder/actions?query=workflow%3ACI+branch%3Amaster)
[![Pub Package](https://img.shields.io/pub/v/cli_readme_builder.svg)](https://pub.dev/packages/cli_readme_builder)
[![package publisher](https://img.shields.io/pub/publisher/cli_readme_builder.svg)](https://pub.dev/packages/cli_readme_builder/publisher)


## Overview
### Purpose

Generate a file which contains --help output from every command in a Dart console application.

### How it Works

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

    `README.md` will be generated with content:

    [comment]: <> (Generated code. Do not modify.)
    ```md
    # Description

    ```

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

[build config]: https://pub.dev/packages/build_config
