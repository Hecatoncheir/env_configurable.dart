# env_configurable.dart

Генератор конфигурационных классов Dart из переменных окружения. Аннотации описывают поля, а `build_runner` создаёт фабрику `fromEnvironment()` с готовыми значениями.

## Состав репозитория

- [env_annotation](env_annotation/README.md) — аннотации `EnvConfigurable` и `EnvKey`.
- [env_configurable](env_configurable/README.md) — генератор на базе `source_gen`.
- [example](example/README.md) — пример с вложенной конфигурацией.

Требуется Dart **3.12 или новее**, в пределах версии 3.x.

## Подключение

Добавьте в `pubspec.yaml` своего проекта:

```yaml
dependencies:
  env_annotation:
    git:
      url: https://github.com/Hecatoncheir/env_configurable.dart.git
      path: env_annotation

dev_dependencies:
  build_runner: ^2.16.2
  env_configurable:
    git:
      url: https://github.com/Hecatoncheir/env_configurable.dart.git
      path: env_configurable
```

Затем выполните `dart pub get`.

## Использование

Создайте `lib/app_config.dart`:

```dart
import 'package:env_annotation/env_annotation.dart';

part 'app_config.g.dart';

@EnvConfigurable()
class AppConfig {
  @EnvKey(environmentKey: 'API_URL', defaultValue: 'http://localhost:8080')
  final String apiUrl;

  @EnvKey(environmentKey: 'PORT', defaultValue: '8080')
  final int port;

  @EnvKey(environmentKey: 'DEBUG', defaultValue: 'false')
  final bool debug;

  AppConfig({required this.apiUrl, required this.port, required this.debug});

  factory AppConfig.fromEnvironment() => _$AppConfigFromEnvironment();
}
```

Передайте окружение процессу генерации (одинаково для bash, zsh и fish):

```sh
env API_URL=https://api.example.com PORT=443 DEBUG=true dart run build_runner build
```

После генерации используйте `AppConfig.fromEnvironment()`.

## Как выбираются значения

Без `EnvKey` имя переменной совпадает с именем поля, включая регистр. `environmentKey` задаёт другое имя, `defaultValue` применяется, если переменной нет. Оба параметра `EnvKey` нужно передавать **строками**, в том числе для чисел и логических значений.

| Тип поля | Если переменной нет | Если значение некорректно |
| --- | --- | --- |
| `String` | `''` | Принимается как строка |
| `int` | `0` | `0` |
| `double` | `0.0` | `0.0` |
| `bool` | `false` | `false` |
| Nullable-варианты | `null` | `null` для чисел и `bool` |

Для `bool` принимаются `true` и `false` без учёта регистра. Для другого типа генератор вызывает `Тип.fromEnvironment()`: такой тип должен предоставлять соответствующую фабрику. Конструктор конфигурации должен принимать все поля как именованные параметры.

## Когда читается окружение

Окружение читается **при генерации**, а значения записываются в `.g.dart`. Изменение окружения запущенного приложения не меняет конфигурацию. Файлы `.env` автоматически не загружаются.

После изменения переменных пересоздайте результат, чтобы сбросить кэш генератора:

```sh
dart run build_runner clean
env API_URL=https://api.example.com PORT=443 DEBUG=true dart run build_runner build
```

Секреты также попадают в генерируемый код; учитывайте это при публикации исходников и сборок. Генерацию выполняйте на Dart VM; готовый код с примитивными значениями можно использовать и во Flutter.

## Разработка и проверка

В каталогах `env_annotation` и `env_configurable` выполните:

```sh
dart pub get
dart analyze --fatal-infos
dart test
```

В каталоге `example` выполните:

```sh
dart pub get
dart run build_runner build
dart analyze --fatal-infos
```

Пример использует `dependency_overrides` на локальные пакеты. Генератор получает аннотации через Git-зависимость.

## Лицензия

[MIT](LICENSE).
