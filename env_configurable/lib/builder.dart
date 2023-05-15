library env_configurable_builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart' hide Generator;

import 'generator.dart';

Builder envConfigurable(BuilderOptions _) => SharedPartBuilder(
      [Generator()],
      'env_configurable',
    );
