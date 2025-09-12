import 'package:analyzer/dart/element/element.dart';
import 'package:env_annotation/env_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'class_field.dart';

final class ClassStructure {
  final String name;
  final List<ClassField> fields;

  ClassStructure({
    required this.name,
    required this.fields,
  });

  ClassStructure.fromClassElement(ClassElement classElement)
      : name = classElement.displayName,
        fields = <ClassField>[] {
    final elementInstanceFields = Map.fromEntries(classElement.fields
        .where((e) => !e.isStatic)
        .map((e) => MapEntry(e.displayName, e)));

    for (final fieldElement in elementInstanceFields.entries) {
      final field = fieldElement.value;
      final type = field.type.toString();
      final name = field.displayName;

      String? defaultValue;
      String? environmentKey;

      final annotations = TypeChecker.typeNamed(EnvKey).annotationsOf(field);
      if (annotations.isNotEmpty) {
        final annotation = annotations.first;
        final reader = ConstantReader(annotation);

        final _defaultValue = reader.read('defaultValue');
        if (!_defaultValue.isNull) defaultValue = _defaultValue.stringValue;

        final _environmentKey = reader.read('environmentKey');
        if (!_environmentKey.isNull) {
          environmentKey = _environmentKey.stringValue;
        }
      }

      final classField = ClassField(
        type: type,
        name: name,
        environmentKey: environmentKey,
        defaultValue: defaultValue,
      );

      fields.add(classField);
    }
  }
}
