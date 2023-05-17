/// parseFieldValueGenerator - get right value for class field;
/// If it required and no value find:
/// bool - false by default,
/// int - 0 by default,
/// double - 0.0 by defaultValue,
/// String - '' empty by default.
Object? parseFieldValue(String typeName, String? value) {
  return switch (typeName) {
    'String?' => value == null ? null : value,
    'String' => value == null ? '' : value,
    'bool?' =>
      value == null ? null : bool.tryParse(value, caseSensitive: false),
    'bool' => value == null
        ? false
        : bool.tryParse(value, caseSensitive: false) ?? false,
    'int?' => value == null ? null : int.tryParse(value),
    'int' => value == null ? 0 : int.tryParse(value) ?? 0,
    'double?' => value == null ? null : double.tryParse(value),
    'double' => value == null ? 0.0 : double.tryParse(value) ?? 0.0,
    _ => null,
  };
}
