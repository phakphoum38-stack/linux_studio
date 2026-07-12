import 'backend_config.dart';
import 'local_backend.dart';
import 'terminal_backend.dart';

TerminalBackend createBackend(BackendConfig config) {
  if (config.kind == BackendKind.auto || config.kind == BackendKind.local) {
    return LocalBackend();
  }
  throw UnsupportedError(
    '${config.kind.name} requires a native platform or remote runtime',
  );
}
