import 'package:env_configurable/env_configurable_generator.dart';
import 'package:test/test.dart';

void main() {
  group('EnvConfigurableGenerator', () {
    late final EnvConfigurableGenerator generator;

    setUpAll(() {
      generator = EnvConfigurableGenerator();
    });
    test('can check support type', () {
      final isSupportString = generator.isSupportType('String');
      expect(isSupportString, isTrue);

      final isSupportBool = generator.isSupportType('bool');
      expect(isSupportBool, isTrue);

      final isSupportInt = generator.isSupportType('int');
      expect(isSupportInt, isTrue);

      final isSupportDouble = generator.isSupportType('double');
      expect(isSupportDouble, isTrue);

      final isSupportSomeTestClass = generator.isSupportType('SomeTestClass');
      expect(isSupportSomeTestClass, isFalse);
    });

    test('can parse String field value', () {
      final stringRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('String', null);

      expect(stringRequiredFieldWithoutValue, equals(''));

      final stringRequiredFieldWithValue =
          generator.parseFieldValueGenerator('String', 'Some test string');

      expect(stringRequiredFieldWithValue, equals('Some test string'));

      final stringNotRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('String?', null);

      expect(stringNotRequiredFieldWithoutValue, isNull);

      final stringNotRequiredFieldWithValue =
          generator.parseFieldValueGenerator('String?', 'Some test string');

      expect(stringNotRequiredFieldWithValue, equals('Some test string'));
    });

    test('can parse int field value', () {
      final intRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('int', null);

      expect(intRequiredFieldWithoutValue, equals(0));

      final intRequiredFieldWithValue =
          generator.parseFieldValueGenerator('int', '100');

      expect(intRequiredFieldWithValue, equals(100));

      final intNotRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('int?', null);

      expect(intNotRequiredFieldWithoutValue, isNull);

      final intNotRequiredFieldWithValue =
          generator.parseFieldValueGenerator('int?', '200');

      expect(intNotRequiredFieldWithValue, equals(200));
    });

    test('can parse double field value', () {
      final doubleRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('double', null);

      expect(doubleRequiredFieldWithoutValue, equals(0.0));

      final doubleRequiredFieldWithValue =
          generator.parseFieldValueGenerator('double', '0.1');

      expect(doubleRequiredFieldWithValue, equals(0.1));

      final doubleNotRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('double?', null);

      expect(doubleNotRequiredFieldWithoutValue, isNull);

      final doubleNotRequiredFieldWithValue =
          generator.parseFieldValueGenerator('double?', '2');

      expect(doubleNotRequiredFieldWithValue, equals(2.0));
    });

    test('can parse bool field value', () {
      final boolRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('bool', null);

      expect(boolRequiredFieldWithoutValue, isFalse);

      final boolRequiredFieldWithValue =
          generator.parseFieldValueGenerator('bool', 'true');

      expect(boolRequiredFieldWithValue, isTrue);

      final boolNotRequiredFieldWithoutValue =
          generator.parseFieldValueGenerator('bool?', null);

      expect(boolNotRequiredFieldWithoutValue, isNull);

      final boolNotRequiredFieldWithValue =
          generator.parseFieldValueGenerator('bool?', 'true');

      expect(boolNotRequiredFieldWithValue, isTrue);
    });

    test('can generate "FromEnvironmentFunction"', () {
      final classStructure = {
        "Class": "class Person",
        "ClassName": "Person",
        "ClassFields": [
          {
            "Field": "String firstName",
            "FieldType": "String",
            "FieldName": "firstName",
            "defaultValue": "Test name"
          },
          {
            "Field": "String?",
            "FieldType": "String?",
            "FieldName": "secondName",
            "environmentKey": "SecondName"
          },
          {
            "Field": "int age",
            "FieldType": "int",
            "FieldName": "age",
          },
          {
            "Field": "bool isOk",
            "FieldType": "bool",
            "FieldName": "isOk",
          },
        ]
      };

      final createdFunction =
          generator.generateFromEnvironmentFunction(classStructure);

      expect(createdFunction, isNotEmpty);

      final expectedCreatedFunction = '''
Person _\$PersonFromEnvironment(){
final personInstance = Person(
firstName: "Test name",
secondName: null,
age: 0,
isOk: false,
);

return personInstance;
}
''';

      expect(expectedCreatedFunction, equals(expectedCreatedFunction));
    });

    test('can prepare class structure', () {});
  });
}
