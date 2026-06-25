#!/usr/bin/env bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "⚙️ Linux Studio Generator"

mkdir -p generated_app/lib

MODULES=(
  terminal
  file_manager
  package_manager
  desktop_vnc
)

for module in "${MODULES[@]}"
do
  mkdir -p "generated_app/lib/$module"
  touch "generated_app/lib/$module/.keep"
  echo "✅ Module prepared: $module"
done

mkdir -p generated_app/lib/core
mkdir -p generated_app/lib/screens
mkdir -p generated_app/lib/widgets

echo "🎉 Generation completed."
