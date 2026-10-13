# Пример env_configurable

Пример конфигурации `Person` со строковыми, числовыми и логическими полями и вложенным объектом `Version`. Исходник: [lib/example.dart](lib/example.dart). Требуется Dart 3.12 или новее, в пределах версии 3.x.

## Подготовка и генерация

Из каталога `example`:

```sh
dart pub get
env firstName=Ivan SecondName=Petrov age=30 isOk=true number=1.2.3 dart run build_runner build
dart analyze --fatal-infos
```

Будет создан `lib/example.g.dart` с фабриками для `Person` и `Version`. В Dart-коде импортируйте `lib/example.dart` и вызовите `Person.fromEnvironment()`.

Это пример библиотеки: точки входа `main()` здесь нет. Переменные читаются при генерации, поэтому для изменения значений выполните:

```sh
dart run build_runner clean
env firstName=Anna age=25 isOk=false dart run build_runner build
```

В `pubspec.yaml` заданы `dependency_overrides`, использующие пакеты из соседних каталогов репозитория. Это позволяет проверять локальные изменения генератора и аннотаций вместе.

Полная инструкция и правила преобразования значений находятся в [основном README](../README.md).
