import 'package:env_configurable/class_field.dart';
import 'package:env_configurable/class_structure.dart';
import 'package:env_configurable/generate_from_environment.dart';
import 'package:env_configurable/is_support_type.dart';
import 'package:env_configurable/parse_field_value.dart';
import 'package:test/test.dart';

void main() {
  group('EnvConfigurableGenerator', () {
    test('can check support type', () {
      final isSupportString = isSupportType('String');
      expect(isSupportString, isTrue);

      final isSupportBool = isSupportType('bool');
      expect(isSupportBool, isTrue);

      final isSupportInt = isSupportType('int');
      expect(isSupportInt, isTrue);

      final isSupportDouble = isSupportType('double');
      expect(isSupportDouble, isTrue);

      final isSupportSomeTestClass = isSupportType('SomeTestClass');
      expect(isSupportSomeTestClass, isFalse);
    });

    test('can parse String field value', () {
      final stringRequiredFieldWithoutValue = parseFieldValue('String', null);
      expect(stringRequiredFieldWithoutValue, equals(''));

      final stringRequiredFieldWithValue =
          parseFieldValue('String', 'Some test string');
      expect(stringRequiredFieldWithValue, equals('Some test string'));

      final stringNotRequiredFieldWithoutValue =
          parseFieldValue('String?', null);
      expect(stringNotRequiredFieldWithoutValue, isNull);

      final stringNotRequiredFieldWithValue =
          parseFieldValue('String?', 'Some test string');
      expect(stringNotRequiredFieldWithValue, equals('Some test string'));
    });

    test('can parse int field value', () {
      final intRequiredFieldWithoutValue = parseFieldValue('int', null);
      expect(intRequiredFieldWithoutValue, equals(0));

      final intRequiredFieldWithEmptyValue = parseFieldValue('int', '');
      expect(intRequiredFieldWithEmptyValue, equals(0));

      final intRequiredFieldWithValue = parseFieldValue('int', '100');
      expect(intRequiredFieldWithValue, equals(100));

      final intNotRequiredFieldWithoutValue = parseFieldValue('int?', null);
      expect(intNotRequiredFieldWithoutValue, isNull);

      final intNotRequiredFieldWithValue = parseFieldValue('int?', '200');
      expect(intNotRequiredFieldWithValue, equals(200));
    });

    test('can parse double field value', () {
      final doubleRequiredFieldWithoutValue = parseFieldValue('double', null);
      expect(doubleRequiredFieldWithoutValue, equals(0.0));

      final intRequiredFieldWithEmptyValue = parseFieldValue('double', '');
      expect(intRequiredFieldWithEmptyValue, equals(0));

      final doubleRequiredFieldWithValue = parseFieldValue('double', '0.1');
      expect(doubleRequiredFieldWithValue, equals(0.1));

      final doubleNotRequiredFieldWithoutValue =
          parseFieldValue('double?', null);
      expect(doubleNotRequiredFieldWithoutValue, isNull);

      final doubleNotRequiredFieldWithValue = parseFieldValue('double?', '2');
      expect(doubleNotRequiredFieldWithValue, equals(2.0));
    });

    test('can parse bool field value', () {
      final boolRequiredFieldWithoutValue = parseFieldValue('bool', null);
      expect(boolRequiredFieldWithoutValue, isFalse);

      final boolRequiredFieldWithValue = parseFieldValue('bool', 'true');
      expect(boolRequiredFieldWithValue, isTrue);

      final boolNotRequiredFieldWithoutValue = parseFieldValue('bool?', null);
      expect(boolNotRequiredFieldWithoutValue, isNull);

      final boolNotRequiredFieldWithValue = parseFieldValue('bool?', 'true');
      expect(boolNotRequiredFieldWithValue, isTrue);
    });

    test('can generate "FromEnvironmentFunction"', () {
      final classStructure = ClassStructure(
        name: 'PersonTestClass',
        fields: [
          ClassField(
            type: 'String',
            name: "firstName",
            defaultValue: "Test name",
          ),
          ClassField(
            type: "String?",
            name: "secondName",
            environmentKey: "SecondName",
          ),
          ClassField(
            type: "int",
            name: "age",
          ),
          ClassField(
            type: "bool",
            name: "isOk",
          ),
        ],
      );

      final createdFunction =
          generateFromEnvironmentClassStructure(classStructure);

      expect(createdFunction, isNotEmpty);

      final expectedCreatedFunction = '''
PersonTestClass _\$PersonTestClassFromEnvironment(){
final personTestClassInstance = PersonTestClass(
firstName: "Test name",
secondName: null,
age: 0,
isOk: false,
);

return personTestClassInstance;
}
''';

      expect(createdFunction, equals(expectedCreatedFunction));
    });
  });
}
