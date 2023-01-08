import 'package:meta/meta.dart';

import 'help_model.dart';

class HelpModelStringBuilder {
  HelpModelStringBuilder._();
  static String getFullOutput(HelpModel model) {
    var output = _fullOutputTemplate;

    output = output.replaceAll(
      '{{cli_name}}',
      model.commandName ?? 'NAME NOT FOUND',
    );
    output = output.replaceFirst(
      '{{cli_description}}',
      model.description.join('\n'),
    );
    output = output.replaceFirst(
      '{{top_level_help_output}}',
      model.entireHelpOutput,
    );
    output = output.replaceFirst(
      '{{commands_list}}',
      getAvailableCommandsList(model).join('\n'),
    );
    output = output.replaceFirst(
      '{{details_of_each_command}}',
      getAllChildCommandDetails(model).join('\n'),
    );

    return output;
  }

  @visibleForTesting
  static String getCommandDetails(HelpModel model) {
    var output = _commandDetailsTemplate;

    output = output.replaceFirst(
      '{{section_label}}',
      _getCommandDetailsLabel(
        commandName: model.commandName ?? 'NAME NOT FOUND',
        parents: model.parents,
      ),
    );

    output = output.replaceFirst(
      '{{command_execution}}',
      '${model.parents} ${model.commandName}'.trim(),
    );

    output = output.replaceFirst(
      '{{help_output}}',
      model.entireHelpOutput,
    );

    return output;
  }

  static String _getCommandDetailsLabel({
    required String commandName,
    required String parents,
  }) {
    final parentList = parents.split(' ').where((e) => e.isNotEmpty);
    var prefix = '';
    // no parents
    //  gets a top level label
    //  this should never happen because we print
    //  the cli_name and description separately
    if (parentList.isEmpty) {
      prefix = '#';
    }
    // child commands of the top level command
    //  are in the commands section, so we start with a header #3
    else if (parentList.length == 1) {
      prefix = '###';
    }

    // child commands of other commands
    //  get a header based on the number of parents
    // ignore: prefer_interpolation_to_compose_strings
    else {
      prefix = '###${'#' * (parentList.length - 1)}';
    }

    // if there is only one parent, it's the cli name, so remove that one
    final parentsWithoutCliName = parentList.skip(1).join(' ');

    return [
      prefix,
      parentsWithoutCliName,
      commandName,
    ].where((e) => e.isNotEmpty).join(' ');
  }

  @visibleForTesting
  static List<String> getAvailableCommandsList(HelpModel model) {
    final lines = <String>[];
    for (var childModel in model.childCommandModels) {
      var line = _commandDetailsLabelTemplate.replaceAll(
        '{{command_name}}',
        childModel.commandName ?? 'NAME NOT FOUND',
      );

      var parentCount = childModel.parents.split(' ').length;

      // The executable will be the parent to all top level commands
      // so remove that one from the count
      parentCount--;

      // Pad the beginning of the line with the number of parents
      //  this will give effect of this command being a child
      //  in the list
      line = '  ' * parentCount + line;

      lines.add(line);

      if (childModel.childCommandModels.isNotEmpty) {
        lines.addAll(getAvailableCommandsList(childModel));
      }
    }
    return lines;
  }

  @visibleForTesting
  static List<String> getAllChildCommandDetails(HelpModel model) {
    final lines = <String>[];
    for (var childModel in model.childCommandModels) {
      final line = getCommandDetails(childModel);

      lines.add(line);

      if (childModel.childCommandModels.isNotEmpty) {
        lines.addAll(getAllChildCommandDetails(childModel));
      }
    }
    return lines; //lines.expand((element) => [element, '']).toList();
  }

  static const _commandDetailsLabelTemplate = '* [{{command_name}}](#{{command_name}})';

  static const _commandDetailsTemplate = '''
{{section_label}}

```sh
{{command_execution}} --help
```

Help output:

```
{{help_output}}
```
''';

  static const _fullOutputTemplate = '''
# {{cli_name}}

{{cli_description}}

## Usage

```sh
{{cli_name}} --help
```

Help output:

```
{{top_level_help_output}}
```

## Available commands

{{commands_list}}

{{details_of_each_command}}
''';
}
