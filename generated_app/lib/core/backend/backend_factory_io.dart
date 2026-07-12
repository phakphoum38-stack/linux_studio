import 'dart:io';

import 'backend_config.dart';
import 'local_backend.dart';
import 'process_terminal_backend.dart';
import 'pty_terminal_backend.dart';
import 'ssh_terminal_backend.dart';
import 'terminal_backend.dart';
import 'windows_terminal_backend.dart';

TerminalBackend createBackend(BackendConfig config) {
  switch (config.kind) {
    case BackendKind.local:
      return LocalBackend();
    case BackendKind.native:
      return _nativeBackend();
    case BackendKind.container:
    case BackendKind.qemu:
      final executable = config.executable;
      if (executable == null || executable.isEmpty) {
        throw ArgumentError('An executable is required for ${config.kind.name}');
      }
      return ProcessTerminalBackend(
        executable: executable,
        arguments: config.arguments,
        environment: config.environment,
        workingDirectory: config.workingDirectory,
      );
    case BackendKind.ssh:
      if (config.host == null ||
          config.username == null ||
          config.password == null) {
        throw ArgumentError('SSH host, username and password are required');
      }
      return SshTerminalBackend.configured(
        host: config.host!,
        port: config.port,
        username: config.username!,
        password: config.password!,
      );
    case BackendKind.auto:
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        return _nativeBackend();
      }
      return LocalBackend();
  }
}

TerminalBackend _nativeBackend() {
  if (Platform.isWindows) return WindowsTerminalBackend();
  if (Platform.isLinux || Platform.isMacOS) return PtyTerminalBackend();
  throw UnsupportedError('A native backend is not available on this platform');
}
