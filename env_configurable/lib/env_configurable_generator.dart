import 'dart:io';

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

    final elementInstanceFields = Map.fromEntries(classElement.fields
        .where((e) => !e.isStatic)
        .map((e) => MapEntry(e.name, e)));

    final classStructure = {};
    classStructure['Class'] = classElement;

    final className = classElement.displayName;
    classStructure['ClassName'] = className;

    classStructure['ClassFields'] = [];

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

    final fromEnvironmentFunction =
        generateFromEnvironmentFunction(classStructure);

    return fromEnvironmentFunction;
  }

  bool isSupportType(String type) {
    const supportedTypes = [
      'String?',
      'String',
      'bool?',
      'bool',
      'int?',
      'int',
    ];

    if (!supportedTypes.contains(type)) return false;

    return true;
  }

  Object? parseFieldValueGenerator(String type, String? value) {
    Object? _value = null;

    if (type.toString() == 'String?') {
      _value = value == null ? null : value.toString();
    }

    if (type.toString() == 'String') {
      _value = value == null ? '' : value.toString();
    }

    if (type.toString() == 'bool?') {
      _value = value == null
          ? null
          : value.toString() == 'true'
              ? true
              : false;
    }

    if (type.toString() == 'bool') {
      _value = value == null
          ? false
          : value.toString() == 'true'
              ? true
              : false;
    }

    if (type.toString() == 'int?') {
      _value = value == null ? null : int.parse(value.toString());
    }

    if (type.toString() == 'int') {
      _value = value == null ? 0 : int.parse(value.toString());
    }

    return _value;
  }

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
