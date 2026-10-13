import 'package:build_test/build_test.dart';
import 'package:env_configurable/env_configurable_generator.dart';
import 'package:source_gen/source_gen.dart' hide Generator;
import 'package:test/test.dart';

void main() {
  group('Generator', () {
    // `testBuilder` разбирает исходник анализатором, и в чистом окружении —
    // в свежем контейнере CI — сначала собирает сводку SDK. В образе CI под
    // эмуляцией тридцати секунд на это не хватило.
    test('EnvConfigurableGenerator', () async {
      final builder = SharedPartBuilder([
        EnvConfigurableGenerator(),
      ], 'env_configurable');

      const sourceAssets = {
        'env_configurable|test/example.dart': '''
        import 'package:env_annotation/env_annotation.dart';
        
        part 'example.g.dart';
        
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
        'env_configurable|test/example.env_configurable.g.part': decodedMatches(
          allOf(
            contains(r'Person _$PersonFromEnvironment()'),
            contains('firstName: "Test name"'),
            contains('secondName: null'),
            contains('age: 0'),
          ),
        ),
      };

      final readerWriter = TestReaderWriter(rootPackage: 'env_configurable');
      await readerWriter.testing.loadIsolateSources();

      await testBuilder(
        builder,
        sourceAssets,
        rootPackage: 'env_configurable',
        readerWriter: readerWriter,
        outputs: outputs,
      );
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
