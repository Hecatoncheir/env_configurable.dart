import 'package:build_test/build_test.dart';
import 'package:env_configurable/env_configurable_generator.dart';
import 'package:source_gen/source_gen.dart' hide Generator;
import 'package:test/test.dart';

void main() {
  group('Generator', () {
    test(
      'EnvConfigurableGenerator',
      () async {
        final builder = SharedPartBuilder(
          [EnvConfigurableGenerator()],
          'env_configurable',
        );

        const sourceAssets = {
          'a|lib/example.dart': '''
        import 'package:env_annotation/env_annotation.dart';
        
        part 'env_configurable.g.dart';
        
        @EnvConfigurable()
        class Person {
          @EnvKey(defaultValue: 'Test name')
          final String firstName;

          final String? secondName;

          int age;

          Person({
            required this.firstName,
            required this.secondName,
            required this.age,
          });
        }
        ''',
        };

        final outputs = {
          'a|lib/example.g.dart': r'''
            // GENERATED CODE - DO NOT MODIFY BY HAND

            part of 'example.dart';

            // **************************************************************************
            // EnvConfigurableGenerator
            // **************************************************************************

            // !
            ''',
        };

        await testBuilder(
          builder,
          sourceAssets,
          // reader: await PackageAssetReader.currentIsolate(),
          outputs: outputs,
        );
      },
      timeout: Timeout(Duration(days: 1)),
      skip: 'Untestable',
    );
  });
}
