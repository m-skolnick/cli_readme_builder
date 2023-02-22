# example_cli

Example CLI app

## Usage

```sh
example_cli --help
```

Help output:

```text
Example CLI app

Usage: example_cli <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  branch_command            Branch Command description
  leaf_command              Leaf Command description
  leaf_command_with_input   Leaf Command description

Run "example_cli help <command>" for more information about a command.
```

## Available commands

* [branch_command](#branch_command)
  * [child_branch_command](#child_branch_command)
    * [leaf_command](#leaf_command)
  * [leaf_command](#leaf_command)
* [leaf_command](#leaf_command)
* [leaf_command_with_input](#leaf_command_with_input)

### branch_command

```sh
example_cli branch_command --help
```

Help output:

```text
Branch Command description

Usage: example_cli branch_command <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  child_branch_command   Child Branch Command description
  leaf_command           Leaf Command description

Run "example_cli help" to see global options.
```

#### branch_command child_branch_command

```sh
example_cli branch_command child_branch_command --help
```

Help output:

```text
Child Branch Command description

Usage: example_cli branch_command child_branch_command <subcommand> [arguments]
-h, --help    Print this usage information.

Available subcommands:
  leaf_command   Leaf Command description

Run "example_cli help" to see global options.
```

##### branch_command child_branch_command leaf_command

```sh
example_cli branch_command child_branch_command leaf_command --help
```

Help output:

```text
Leaf Command description

Usage: example_cli branch_command child_branch_command leaf_command [arguments]
-h, --help    Print this usage information.

Run "example_cli help" to see global options.
```

#### branch_command leaf_command

```sh
example_cli branch_command leaf_command --help
```

Help output:

```text
Leaf Command description

Usage: example_cli branch_command leaf_command [arguments]
-h, --help    Print this usage information.

Run "example_cli help" to see global options.
```

### leaf_command

```sh
example_cli leaf_command --help
```

Help output:

```text
Leaf Command description

Usage: example_cli leaf_command [arguments]
-h, --help    Print this usage information.

Run "example_cli help" to see global options.
```

### leaf_command_with_input

```sh
example_cli leaf_command_with_input --help
```

Help output:

```text
Leaf Command description

Usage: example_cli leaf_command_with_input [arguments]
-h, --help                                  Print this usage information.
    --option_arg=<value help for option>    An option argument
    --[no-]flag_arg                         A flag argument

Run "example_cli help" to see global options.
```

