library env_configurable_builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'env_configurable_generator.dart';

Builder envConfigurable(BuilderOptions _) => SharedPartBuilder(
      [EnvConfigurableGenerator()],
      'env_configurable',
    );
