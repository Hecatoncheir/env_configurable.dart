import 'dart:io';

import 'package:env_configurable/class_structure.dart';
import 'package:recase/recase.dart';

import 'is_support_type.dart';
import 'parse_field_value.dart';

/// generateFromEnvironmentFunction - make function:
/// ${ClassName} _${ClassName}FromEnvironment()
/// Example:
/// Person _$PersonFromEnvironment() {
//   final personInstance = Person(
//     firstName: "Test name",
//     secondName: null,
//     age: 0,
//     isOk: false,
//     version: Version.fromEnvironment(),
//   );
//
//   return personInstance;
// }
String generateFromEnvironmentClassStructure(ClassStructure classStructure) {
  // Begin.
  final buf = StringBuffer();

  final className = classStructure.name;
  buf.writeln("$className _\$${className}FromEnvironment(){");

  final classFields = classStructure.fields;

  // Create function body:

  // Create class:

  buf.writeln(
    'final ${ReCase(className).camelCase}Instance = $className(',
  );

  final environments = Platform.environment;

  // Parameters:
  for (final fieldStructure in classFields) {
    final fieldName = fieldStructure.name;
    final fieldType = fieldStructure.type;
    final fieldEnvironmentKey = fieldStructure.environmentKey;
    final fieldDefaultValue = fieldStructure.defaultValue;

    String? value;
    if (fieldEnvironmentKey == null) {
      value = environments[fieldName]?.toString();
    }

    if (fieldEnvironmentKey != null) {
      value = environments[fieldEnvironmentKey]?.toString();
    }

    if (value == null && fieldDefaultValue != null) {
      value = fieldDefaultValue.toString();
    }

    if (!isSupportType(fieldType)) {
      final fieldValue = '${fieldType}' + '.fromEnvironment()';
      buf.writeln(
        '$fieldName: $fieldValue,',
      );
    } else {
      final fieldValue = parseFieldValue(fieldType, value);
      buf.writeln(
        '$fieldName: ${fieldValue is String ? '"' + fieldValue + '"' : fieldValue},',
      );
    }
  }

  buf.writeln(');');

  buf.writeln();

  buf.writeln('return ${ReCase(className).camelCase}Instance;');

  // End.
  buf.writeln("}");

  return buf.toString();
}
