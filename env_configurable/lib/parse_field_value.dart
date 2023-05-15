/// parseFieldValueGenerator - get right value for class field;
/// If it required and no value find:
/// bool - false by default,
/// int - 0 by default,
/// double - 0.0 by defaultValue,
/// String - '' empty by default.
Object? parseFieldValue(String type, String? value) {
  Object? _value = null;

  if (type == 'String?') {
    _value = value == null ? null : value;
  }

  if (type == 'String') {
    _value = value == null ? '' : value;
  }

  if (type == 'bool?') {
    _value = value == null
        ? null
        : value == 'true'
            ? true
            : false;
  }

  if (type == 'bool') {
    _value = value == null
        ? false
        : value == 'true'
            ? true
            : false;
  }

  if (type == 'int?') {
    _value = value == null ? null : int.tryParse(value) ?? 0;
  }

  if (type == 'int') {
    _value = value == null ? 0 : int.tryParse(value) ?? 0;
  }

  if (type == 'double?') {
    _value = value == null ? null : double.tryParse(value) ?? 0.0;
  }

  if (type == 'double') {
    _value = value == null ? 0.0 : double.tryParse(value) ?? 0.0;
  }

  return _value;
}
