
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED

PROJECT_ROOT = Path(__file__).resolve().parent.parent
ZIP_PATH = PROJECT_ROOT / "remarcable_submission.zip"

EXCLUDED_DIRS = {
    ".venv",
    ".git",
    "__pycache__",
    ".ipynb_checkpoints",
    ".pytest_cache",
    "target",
    "logs",
}

EXCLUDED_SUFFIXES = {
    ".pyc",
}

EXCLUDED_FILES = {
    ".DS_Store",
}

with ZipFile(ZIP_PATH, "w", ZIP_DEFLATED) as archive:
    for path in PROJECT_ROOT.rglob("*"):
        if not path.is_file():
            continue

        relative_path = path.relative_to(PROJECT_ROOT)

        if path == ZIP_PATH:
            continue

        if any(part in EXCLUDED_DIRS for part in relative_path.parts):
            continue

        if path.suffix in EXCLUDED_SUFFIXES:
            continue

        if path.name in EXCLUDED_FILES:
            continue

        archive.write(path, relative_path)

print(f"Created submission: {ZIP_PATH}")
print(f"Size: {ZIP_PATH.stat().st_size / (1024**2):.2f} MB")