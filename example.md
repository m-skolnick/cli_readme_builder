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