# env_configurable

Генератор Dart-классов с конфигурацией из переменных окружения. Использует `source_gen` и `build`, обрабатывает аннотации из [env_annotation](../env_annotation/README.md). Требуется Dart 3.12 или новее, в пределах версии 3.x.

## Установка

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

Выполните `dart pub get`, добавьте `@EnvConfigurable()` к классу, директиву `part 'имя_файла.g.dart';` и фабрику, вызывающую `_$ИмяКлассаFromEnvironment()`. Конструктор должен принимать поля как именованные параметры. Полный исходник приведён в [основном README](../README.md#использование).

## Генерация

В каталоге своего приложения:

```sh
env PORT=8080 DEBUG=true dart run build_runner build
```

Генератор читает окружение текущего процесса и сохраняет значения в `.g.dart`. Для обновления значений выполните `dart run build_runner clean`, затем повторите генерацию с новым окружением.

Поддерживаются `String`, `int`, `double`, `bool` и их nullable-варианты. Для остальных типов вызывается `Тип.fromEnvironment()`. Правила преобразования и значений по умолчанию описаны в [таблице](../README.md#как-выбираются-значения).

Файлы `.env` автоматически не читаются. Значения, включая секреты, становятся частью сгенерированного исходника и сборки.

## Проверка генератора

Из каталога `env_configurable`:

```sh
dart pub get
dart analyze --fatal-infos
dart test
```

Для проверки локальных пакетов вместе выполните генерацию в [example](../example/README.md).

## Лицензия

[MIT](LICENSE).
