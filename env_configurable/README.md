Generate class with properties from environment variables.


## enc_annotation
[Source code](https://github.com/Hecatoncheir/env_configurable.dart/tree/master/env_annotation)


## env_configurable
[Source code](https://github.com/Hecatoncheir/env_configurable.dart/tree/master/env_configurable)

Требуется Dart 3.12 или новее.

## Setup

`pubspec.yaml`

```yaml
dependencies:
  env_annotation:
    git:
      url: https://github.com/Hecatoncheir/env_configurable.dart.git
      path: env_annotation

dev_dependencies:
  build_runner: ^2.16.0
  env_configurable:
    git:
      url: https://github.com/Hecatoncheir/env_configurable.dart.git
      path: env_configurable
```

Run `dart run build_runner build` after changing annotations or environment
values.

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
dart run build_runner build
```
