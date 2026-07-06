#!/usr/bin/env bash

set -e

echo "🚀 Linux Studio Bootstrap"

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "📁 Project Root: $ROOT_DIR"

# ตรวจสอบ Flutter
if ! command -v flutter >/dev/null 2>&1; then
  echo "❌ Flutter not found."
  exit 1
fi

echo "✅ Flutter found:"
flutter --version

# สร้างโฟลเดอร์พื้นฐาน
mkdir -p native
mkdir -p generated_app
mkdir -p templates
mkdir -p assets

# Clone iSH Fork
if [ ! -d "native/ish_core" ]; then
  echo "📥 Cloning iSH Fork..."
  git clone https://github.com/phakphoum38-stack/ish.git native/ish_core
else
  echo "🔄 Updating iSH Fork..."
  git -C native/ish_core pull
fi

# สร้างหรืออัปเดต generated_app pubspec.yaml
if [ ! -f "generated_app/pubspec.yaml" ]; then
  echo "📝 Creating generated_app/pubspec.yaml..."
  ./scripts/generate.sh
fi

echo "📦 Installing Flutter packages (Root)..."
flutter pub get

echo "📦 Installing Flutter packages (Generated App)..."
flutter pub get -C generated_app || true

echo "✅ Bootstrap completed."
