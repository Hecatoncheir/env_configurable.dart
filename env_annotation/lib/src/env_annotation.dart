class EnvConfigurable {
  const EnvConfigurable();
}

class EnvKey {
  final Object? environmentKey;
  final Object? defaultValue;

  const EnvKey({
    this.environmentKey,
    this.defaultValue,
  });
}
