import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:env_annotation/env_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'class_structure.dart';
import 'generate_from_environment.dart';

class Generator extends GeneratorForAnnotation<EnvConfigurable> {
  @override
  Future<String> generateForAnnotatedElement(
    Element classElement,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (classElement is! ClassElement) {
      throw InvalidGenerationSourceError(
        '`@EnvConfigurable` can only be used on classes.',
        element: classElement,
      );
    }

    final classStructure = ClassStructure.fromClassElement(classElement);
    final fromEnvironmentClassStructure =
        generateFromEnvironmentClassStructure(classStructure);

    return fromEnvironmentClassStructure;
  }
}
