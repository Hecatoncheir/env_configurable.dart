final class ClassField {
  final String type;
  final String name;
  final String? environmentKey;
  final String? defaultValue;

  ClassField({
    required this.type,
    required this.name,
    this.environmentKey,
    this.defaultValue,
  });
}
