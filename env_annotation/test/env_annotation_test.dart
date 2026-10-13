import 'package:env_annotation/env_annotation.dart';
import 'package:test/test.dart';

void main() {
  test('EnvKey stores generator metadata', () {
    const key = EnvKey(environmentKey: 'APP_NAME', defaultValue: 'planner');

    expect(key.environmentKey, 'APP_NAME');
    expect(key.defaultValue, 'planner');
  });
}
