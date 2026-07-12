import 'backend_factory_stub.dart'
    if (dart.library.io) 'backend_factory_io.dart' as platform;
import 'backend_config.dart';
import 'terminal_backend.dart';

class BackendFactory {
  static TerminalBackend create([BackendConfig config = const BackendConfig()]) =>
      platform.createBackend(config);
}
