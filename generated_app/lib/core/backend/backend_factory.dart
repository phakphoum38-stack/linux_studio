import 'dart:io';

import 'native_pty_backend.dart';
import 'pty_terminal_backend.dart';
import 'ssh_terminal_backend.dart';
import 'terminal_backend.dart';

enum TerminalMode {
  local,
  ssh,
}

class BackendFactory {
  const BackendFactory._();

  static TerminalBackend create({
    TerminalMode mode = TerminalMode.local,
  }) {
    switch (mode) {
      case TerminalMode.local:
        return _createLocal();

      case TerminalMode.ssh:
        return SshTerminalBackend();
    }
  }

  static TerminalBackend _createLocal() {
    if (Platform.isWindows) {
      return PtyTerminalBackend();
    }

    if (Platform.isLinux || Platform.isMacOS) {
      return NativePtyBackend();
    }

    throw UnsupportedError(
      'Local terminal is not supported on this platform.',
    );
  }

  static TerminalBackend createSSH() {
    return SshTerminalBackend();
  }

  static bool get supportsLocal =>
      Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS;

  static String get platformName {
    if (Platform.isWindows) {
      return 'Windows ConPTY';
    }

    if (Platform.isLinux) {
      return 'Linux PTY';
    }

    if (Platform.isMacOS) {
      return 'macOS PTY';
    }

    return Platform.operatingSystem;
  }
}
