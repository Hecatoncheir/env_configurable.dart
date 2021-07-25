import 'dart:io';
import 'package:meta/meta.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:env_annotation/env_annotation.dart';

class EnvConfigurableGenerator extends GeneratorForAnnotation<EnvConfigurable> {
  @override
  generateForAnnotatedElement(
    Element classElement,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (classElement is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@EnvConfigurable` can only be used on classes.',
        element: classElement,
      );
    }

    final classStructure = prepareClassStructure(classElement);

    final fromEnvironmentFunction =
        generateFromEnvironmentFunction(classStructure);

    return fromEnvironmentFunction;
  }

  /// prepareStructure - create map like:
  /// {
  //    "Class":"class Person",
  //    "ClassName":"Person",
  //    "ClassFields":[
  //       {
  //          "Field":"String firstName",
  //          "FieldType":"String",
  //          "FieldName":"firstName",
  //          "defaultValue":"Test name"
  //       },
  //       {
  //          "Field":"String?
  //          "FieldType":"String?",
  //          "FieldName":"secondName",
  //          "environmentKey":"SecondName"
  //       },
  //       {
  //          "Field":"int age",
  //          "FieldType":"int",
  //          "FieldName":"age"
  //       },
  //       {
  //          "Field":"bool isOk",
  //          "FieldType":"bool",
  //          "FieldName":"isOk"
  //       },
  //       {
  //          "Field":"Version version",
  //          "FieldType":"Version",
  //          "FieldName":"version"
  //       }
  //    ]
  // }
  @visibleForTesting
  Map<String, dynamic> prepareClassStructure(ClassElement classElement) {
    final classStructure = <String, dynamic>{};
    classStructure['Class'] = classElement;

    final className = classElement.displayName;
    classStructure['ClassName'] = className;

    classStructure['ClassFields'] = [];

    final elementInstanceFields = Map.fromEntries(classElement.fields
        .where((e) => !e.isStatic)
        .map((e) => MapEntry(e.name, e)));

    for (final fieldElement in elementInstanceFields.entries) {
      final classFieldStructure = {};

      final field = fieldElement.value;
      classFieldStructure['Field'] = field;

      final fieldType = field.type.toString();
      classFieldStructure['FieldType'] = fieldType;

      final fieldName = field.displayName;
      classFieldStructure['FieldName'] = fieldName;

      final annotations = TypeChecker.fromRuntime(EnvKey).annotationsOf(field);
      if (annotations.isNotEmpty) {
        final annotation = annotations.first;
        final reader = ConstantReader(annotation);

        final defaultValue = reader.read('defaultValue');
        if (!defaultValue.isNull) {
          final _defaultValue = defaultValue.stringValue;
          classFieldStructure['defaultValue'] = _defaultValue;
        }

        final environmentKey = reader.read('environmentKey');
        if (!environmentKey.isNull) {
          final _environmentKey = environmentKey.stringValue;
          classFieldStructure['environmentKey'] = _environmentKey;
        }
      }

      classStructure['ClassFields'].add(classFieldStructure);
    }

    return classStructure;
  }

  /// isSupportType - check if type of field support for parse.
  @visibleForTesting
  bool isSupportType(String type) {
    const supportedTypes = [
      'String?',
      'String',
      'bool?',
      'bool',
      'int?',
      'int',
      'double',
      'double!'
    ];

    if (!supportedTypes.contains(type)) return false;

    return true;
  }

  /// parseFieldValueGenerator - get right value for class field;
  /// If it required and no value find:
  /// bool - false by default,
  /// int - 0 by default,
  /// double - 0.0 by defaultValue,
  /// String - '' empty by default.
  @visibleForTesting
  Object? parseFieldValueGenerator(String type, String? value) {
    Object? _value = null;

    if (type == 'String?') {
      _value = value == null ? null : value;
    }

    if (type == 'String') {
      _value = value == null ? '' : value;
    }

    if (type == 'bool?') {
      _value = value == null
          ? null
          : value == 'true'
              ? true
              : false;
    }

    if (type == 'bool') {
      _value = value == null
          ? false
          : value == 'true'
              ? true
              : false;
    }

    if (type == 'int?') {
      _value = value == null ? null : int.parse(value);
    }

    if (type == 'int') {
      _value = value == null ? 0 : int.parse(value);
    }

    if (type == 'double?') {
      _value = value == null ? null : double.parse(value);
    }

    if (type == 'double') {
      _value = value == null ? 0.0 : double.parse(value);
    }

    return _value;
  }

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
  @visibleForTesting
  String generateFromEnvironmentFunction(Map classStructure) {
    // Begin.
    final buf = StringBuffer();

    final className = classStructure['ClassName'];
    buf.writeln("$className _\$${className}FromEnvironment(){");

    final classFields = classStructure['ClassFields'];

    // Create function body:

    // Create class:

    buf.writeln(
      'final ${className.toString().toLowerCase()}Instance = $className(',
    );

    final environments = Platform.environment;

    // Parameters:
    for (final fieldStructure in classFields) {
      final field = fieldStructure['Field'];
      final fieldName = fieldStructure['FieldName'];
      final fieldType = fieldStructure['FieldType'];
      final fieldDefaultValue = fieldStructure['defaultValue'];
      final fieldEnvironmentKey = fieldStructure['environmentKey'];

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
        final fieldValue = '${field.type}' + '.fromEnvironment()';
        buf.writeln(
          '$fieldName: $fieldValue,',
        );
      } else {
        final fieldValue = parseFieldValueGenerator(fieldType, value);
        buf.writeln(
          '$fieldName: ${fieldValue is String ? '"' + fieldValue + '"' : fieldValue},',
        );
      }
    }

    buf.writeln(');');

    buf.writeln();

    buf.writeln('return ${className.toString().toLowerCase()}Instance;');

    // End.
    buf.writeln("}");

    return buf.toString();
  }
}
