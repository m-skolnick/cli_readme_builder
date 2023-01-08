import 'package:cli_readme_builder/src/help_model/help_model.dart';
import 'package:cli_readme_builder/src/help_model/help_model_string_builder.dart';
import 'package:test/test.dart';

const _mockCliName = '_mockCliName';
const _mockCommandName = '_mockCommandName';
const _mockDescription = '_mockDescription';
const _mockHelpOutput = '_mockHelpOutput';

HelpModel _getMockModel({
  required String parents,
  String commandName = _mockCommandName,
  List<HelpModel> subCommandModels = const [],
}) =>
    HelpModel(
      commandName: commandName,
      description: [_mockDescription],
      entireHelpOutput: _mockHelpOutput,
      parents: parents,
      childCommands: [],
      childCommandModels: subCommandModels,
    );

void main() {
  group('HelpModelStringBuilder', () {
    test(
      'correctly builds '
      'single command output of top level command',
      () {
        final model = _getMockModel(parents: '');

        final expectedOutput = '''
# $_mockCommandName

```sh
$_mockCommandName --help
```

Help output:

```
$_mockHelpOutput
```
'''
            .split('\n');

        final result = HelpModelStringBuilder.getCommandDetails(model).split('\n');

        expect(result, equals(expectedOutput));
      },
    );
    test(
      'correctly builds '
      'single command output of child command',
      () {
        final model = _getMockModel(parents: _mockCliName);

        final expectedOutput = '''
### $_mockCommandName

```sh
$_mockCliName $_mockCommandName --help
```

Help output:

```
$_mockHelpOutput
```
'''
            .split('\n');

        final result = HelpModelStringBuilder.getCommandDetails(model).split('\n');

        expect(result, equals(expectedOutput));
      },
    );
    test(
      'correctly builds '
      'available command list',
      () {
        final model = _getMockModel(
          parents: '',
          subCommandModels: [
            _getMockModel(
              commandName: 'command_1',
              parents: _mockCliName,
              subCommandModels: [
                _getMockModel(
                  parents: '$_mockCliName command_1',
                  commandName: 'command_1_a',
                  subCommandModels: [
                    _getMockModel(
                      parents: '$_mockCliName command_1 command_1_a',
                      commandName: 'command_1_a_1',
                    ),
                  ],
                ),
              ],
            ),
            _getMockModel(
              parents: _mockCliName,
              commandName: 'command_2',
            ),
            _getMockModel(
              parents: _mockCliName,
              commandName: 'command_3',
            ),
          ],
        );

        final expectedOutput = '''
* [command_1](#command_1)
  * [command_1_a](#command_1_a)
    * [command_1_a_1](#command_1_a_1)
* [command_2](#command_2)
* [command_3](#command_3)'''
            .split('\n');

        final result = HelpModelStringBuilder.getAvailableCommandsList(model);

        expect(result, equals(expectedOutput));
      },
    );
    test(
      'correctly builds '
      'full output',
      () {
        final model = _getMockModel(
          commandName: _mockCliName,
          parents: '',
          subCommandModels: [
            _getMockModel(
              commandName: 'command_1',
              parents: _mockCliName,
              subCommandModels: [
                _getMockModel(
                  parents: '$_mockCliName command_1',
                  commandName: 'command_1_a',
                ),
              ],
            ),
            _getMockModel(
              parents: _mockCliName,
              commandName: 'command_2',
            ),
          ],
        );

        final expectedOutput = '''
# $_mockCliName

$_mockDescription

## Usage

```sh
$_mockCliName --help
```

Help output:

```
$_mockHelpOutput
```

## Available commands

* [command_1](#command_1)
  * [command_1_a](#command_1_a)
* [command_2](#command_2)

### command_1

```sh
$_mockCliName command_1 --help
```

Help output:

```
$_mockHelpOutput
```

#### command_1 command_1_a

```sh
$_mockCliName command_1 command_1_a --help
```

Help output:

```
$_mockHelpOutput
```

### command_2

```sh
$_mockCliName command_2 --help
```

Help output:

```
$_mockHelpOutput
```

'''
            .split('\n');

        final result = HelpModelStringBuilder.getFullOutput(model).split('\n');

        expect(result, equals(expectedOutput));
      },
    );
  });
}
