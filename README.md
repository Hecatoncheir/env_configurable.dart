Generate class with properties from environment variables.


## enc_annotation
[Source code](https://github.com/Hecatoncheir/env_configurable.dart/tree/master/env_annotation)


## env_configurable
[Source code](https://github.com/Hecatoncheir/env_configurable.dart/tree/master/env_configurable)

## Setup

`pubspec.yaml`

```yaml
dependencies:
  env_annotation: 
    git: 
      url: https://github.com/Hecatoncheir/env_annotation.dart.git
      path: env_annotation

dev_dependencies:
  build_runner: ^2.0.0
  env_configurable:
    git: 
      url: https://github.com/Hecatoncheir/env_configurable.dart.git
      path: env_configurable
```

Run `dart run build_runner build`:
```bash
[INFO] Generating build script completed, took 479ms
[INFO] Reading cached asset graph completed, took 60ms
[INFO] Checking for updates since last build completed, took 608ms
[WARNING] Invalidating asset graph due to build script update!
[INFO] Cleaning up outputs from previous builds. completed, took 13ms
[INFO] Generating build script completed, took 177ms
[WARNING] Invalidated precompiled build script due to missing asset graph.
[INFO] Precompiling build script... completed, took 1.4s
[INFO] Building new asset graph completed, took 694ms
[INFO] Checking for unexpected pre-existing outputs. completed, took 1ms
[INFO] Running build completed, took 886ms
[INFO] Caching finalized dependency graph completed, took 38ms
[INFO] Succeeded after 935ms with 3 outputs (4 actions)
```

## Example

```dart
import 'package:env_annotation/env_annotation.dart';

part 'person.g.dart';

@EnvConfigurable()
class Person {
  @EnvKey(defaultValue: 'Test name')
  final String firstName;

  @EnvKey(environmentKey: 'SecondName')
  final String? secondName;

  int age;

  bool isOk;

  Person({
    required this.firstName,
    required this.secondName,
    required this.age,
    required this.isOk,
  });

  factory Person.fromEnvironment() => _$PersonFromEnvironment();
}

```

```dart
part of 'person.dart';

Person _$PersonFromEnvironment() {
  final personInstance = Person(
    firstName: "Test name",
    secondName: "Second name",
    age: 0,
    isOk: true,
  );

  return personInstance;
}
```

After change environment use `dart run` commands for rebuild:
```bash
export isOk=true
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```
