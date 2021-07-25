import 'package:env_configurable/env_configurable_generator.dart';
import 'package:test/test.dart';

void main() {
  group('EnvConfigurableGenerator', () {
    test('can check support type', () {});
    test('can parse field value', () {});
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

      final generator = EnvConfigurableGenerator();

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
