import 'help_model.dart';

class HelpModelStringBuilder {
  final HelpModel model;

  HelpModelStringBuilder(this.model);

  String toOutput() => '''
```sh
${model.parents} ${model.commandName} --help
```

Help output:

```
${model.entireHelpOutput}
```
''';

  String _getAvailableCommands(HelpModel model) {
    final lines = <String>[];
    for (var command in model.subCommandOutput) {
      lines.add('* [${command.commandName}](#${command.commandName})');
    }
    return lines.join('\n');
  }

  String generateOutput() {
    var output = _outputTemplate;

    output = output.replaceFirst(
      '{{description}}',
      model.description.join('\n'),
    );
    output = output.replaceFirst(
      '{{cli_help}}',
      toOutput(),
    );
    output = output.replaceFirst(
      '{{commands_list}}',
      _getAvailableCommands(model),
    );
    output = output.replaceFirst(
      '{{help_output_from_each_command}}',
      '',
    );

    return output;
  }

  static const _outputTemplate = '''
# {{description}}

## Usage

{{cli_help}}

## Available commands

{{commands_list}}

{{help_output_from_each_command}}
''';
}
