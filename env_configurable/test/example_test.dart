import 'package:test/test.dart';

import 'example.dart';

void main() {
  group('example', () {
    test('can create with default value', () {
      final person = Person.fromEnvironment();
      expect(person.firstName, equals('Test name'));
      expect(person.secondName, isNull);
      expect(person.age, equals(0));
      expect(person.version.number, equals('0.0.0'));
      expect(person.version.minorNumber, equals(''));
    });
  });
}
