# env_annotation

Аннотации для генератора конфигурации [env_configurable](../env_configurable/README.md). Пакет содержит только описание аннотаций и не читает окружение самостоятельно. Требуется Dart 3.12 или новее, в пределах версии 3.x.

## Подключение

```yaml
dependencies:
  env_annotation:
    git:
      url: https://github.com/Hecatoncheir/env_configurable.dart.git
      path: env_annotation
```

Выполните `dart pub get`. Для генерации также подключите `env_configurable` и `build_runner`, как показано в [полной инструкции](../README.md).

## Аннотации

```dart
import 'package:env_annotation/env_annotation.dart';

@EnvConfigurable()
class Config {
  @EnvKey(environmentKey: 'PORT', defaultValue: '8080')
  final int port;

  Config({required this.port});
}
```

- `@EnvConfigurable()` — включает генерацию фабрики для класса.
- `@EnvKey(environmentKey: 'PORT')` — задаёт имя переменной окружения; без него используется имя поля.
- `@EnvKey(defaultValue: '8080')` — задаёт значение при отсутствии переменной.

Параметры `EnvKey` передавайте строками: генератор преобразует их в тип поля. Для использования фабрики добавьте директиву `part` и `fromEnvironment()`, как в [примере](../README.md#использование).

## Проверка пакета

Из каталога `env_annotation`:

```sh
dart pub get
dart analyze --fatal-infos
dart test
```

## Лицензия

[MIT](LICENSE).
