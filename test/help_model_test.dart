// ignore_for_file: strict_raw_type

import 'package:cli_readme_builder/src/help_model/help_model.dart';
import 'package:test/test.dart';

void main() {
  group('HelpModel', () {
    test(
      'compares models based on name',
      () {
        final modela = HelpModel(
          commandName: 'a',
          description: [],
          entireHelpOutput: 'entireHelpOutput',
          parents: 'parents',
          childCommands: [],
          childCommandModels: [],
        );
        final modelb = HelpModel(
          commandName: 'b',
          description: [],
          entireHelpOutput: 'entireHelpOutput',
          parents: 'parents',
          childCommands: [],
          childCommandModels: [],
        );

        expect(modela.compareTo(modelb), -1);
      },
    );
    test(
      'uses parents as fallback to name',
      () {
        final modela = HelpModel(
          commandName: null,
          description: [],
          entireHelpOutput: 'entireHelpOutput',
          parents: 'a',
          childCommands: [],
          childCommandModels: [],
        );
        final modelb = HelpModel(
          commandName: null,
          description: [],
          entireHelpOutput: 'entireHelpOutput',
          parents: 'b',
          childCommands: [],
          childCommandModels: [],
        );

        expect(modela.compareTo(modelb), -1);
      },
    );
  });
}
