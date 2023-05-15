/// isSupportType - check if type of field support for parse.
bool isSupportType(String type) {
  const supportedTypes = [
    'String?',
    'String',
    'bool?',
    'bool',
    'int?',
    'int',
    'double',
    'double!',
  ];

  if (!supportedTypes.contains(type)) return false;

  return true;
}
