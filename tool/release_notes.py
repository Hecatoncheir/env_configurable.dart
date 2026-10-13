"""Проверяет версию релиза и извлекает заметки из CHANGELOG."""

import re
import sys
from pathlib import Path


def main():
    tag, output = sys.argv[1:]
    version = tag.removeprefix("v")
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise SystemExit("Тег должен иметь вид 3.4.0 или v3.4.0")

    for package in ("env_annotation", "env_configurable"):
        pubspec = Path(package, "pubspec.yaml").read_text()
        match = re.search(r"^version: (\S+)$", pubspec, re.MULTILINE)
        if match is None or match[1] != version:
            raise SystemExit(f"Версия {package} не совпадает с тегом {tag}")

    changelog = Path("CHANGELOG.md").read_text()
    section = re.search(
        rf"^## {re.escape(version)}(?: — [^\n]+)?\n(.*?)(?=^## |\Z)",
        changelog,
        re.MULTILINE | re.DOTALL,
    )
    if section is None or not section[1].strip():
        raise SystemExit(f"В CHANGELOG нет заметок для {version}")
    Path(output).write_text(section[1].strip() + "\n")


if __name__ == "__main__":
    main()
