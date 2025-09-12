// dart run build_runner build

// ignore_for_file: prefer-match-file-name

import 'package:env_annotation/env_annotation.dart';

part 'example.g.dart';

@EnvConfigurable()
class Person {
  @EnvKey(defaultValue: 'Test name')
  final String firstName;

  @EnvKey(environmentKey: 'SecondName')
  final String? secondName;

  int age;

  bool isOk;

  Version version;

  Person({
    required this.firstName,
    required this.secondName,
    required this.age,
    required this.isOk,
    required this.version,
  });

  factory Person.fromEnvironment() => _$PersonFromEnvironment();
}

@EnvConfigurable()
class Version {
  @EnvKey(defaultValue: '0.0.0')
  final String number;

  Version({
    required this.number,
  });

  factory Version.fromEnvironment() => _$VersionFromEnvironment();
}
