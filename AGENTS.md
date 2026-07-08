# Linux Studio AI Agent Instructions

## Purpose
Help AI coding agents work effectively in this repo by describing the real app entrypoint, build flow, and project layout.

## Repository structure
- The actual Flutter app lives under `generated_app/`.
- `generated_app/lib/` contains the app source, including:
  - `core/` for terminal engine, input pipeline, backend, rendering, and session management
  - `screens/` for main UI screens
- `generated_app/native/` contains platform-native support, including `windows/conpty`.
- `native/ish_core` is an external iSH fork used for Linux terminal functionality.
- `scripts/` contains helper scripts for bootstrap and generating module folders.
- `project.yaml` defines enabled modules and experimental features.

## Primary workflow
- Bootstrap project: `./scripts/bootstrap.sh`
- Install packages:
  - `flutter pub get`
  - `flutter pub get -C generated_app`
- Static analysis: `flutter analyze`
- Run/build app from `generated_app/`:
  - `flutter run` or `flutter build ios --release --no-codesign`
- Windows native backend build if needed:
  - `generated_app/native/windows/conpty/build.ps1`

## Key conventions
- Do not assume the app is rooted at repository root; `generated_app/` is the actual Flutter app folder.
- Preserve the bootstrap and generate scripts because they prepare `generated_app` and clone/update `native/ish_core`.
- The repo mixes Flutter UI code with a custom terminal/VT engine and native platform integration, so be careful when changing terminal handling or backend interfaces.
- `project.yaml` is a config source for enabled modules and should only be edited when module behavior changes are intended.

## AI guidance
- Focus feature work in `generated_app/lib/` first.
- Keep native integration changes isolated and small.
- Prefer preserving current Flutter package versions unless an upgrade is necessary to fix a bug.
- If the task touches platform-specific code, verify whether the change belongs in `generated_app/native/` or in the Flutter-side backend adapter.

## Important files
- `generated_app/lib/main.dart`
- `generated_app/lib/screens/terminal_screen.dart`
- `generated_app/lib/core/engine/`
- `generated_app/lib/core/backend/`
- `generated_app/native/windows/conpty/build.ps1`
- `native/ish_core`
- `scripts/bootstrap.sh`
- `scripts/generate.sh`
- `project.yaml`
