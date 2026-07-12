enum BackendKind { auto, local, native, container, qemu, ssh }

/// Platform-neutral description of a Linux Studio runtime.
class BackendConfig {
  final BackendKind kind;
  final String? executable;
  final List<String> arguments;
  final Map<String, String> environment;
  final String? workingDirectory;
  final String? host;
  final int port;
  final String? username;
  final String? password;

  const BackendConfig({
    this.kind = BackendKind.auto,
    this.executable,
    this.arguments = const [],
    this.environment = const {},
    this.workingDirectory,
    this.host,
    this.port = 22,
    this.username,
    this.password,
  });

  const BackendConfig.native() : this(kind: BackendKind.native);
  const BackendConfig.local() : this(kind: BackendKind.local);

  factory BackendConfig.container({
    required String image,
    String engine = 'docker',
    List<String> arguments = const [],
  }) => BackendConfig(
        kind: BackendKind.container,
        executable: engine,
        arguments: ['run', '--rm', '-i', ...arguments, image],
      );

  factory BackendConfig.qemu({
    required String executable,
    required List<String> arguments,
  }) => BackendConfig(
        kind: BackendKind.qemu,
        executable: executable,
        arguments: arguments,
      );

  factory BackendConfig.ssh({
    required String host,
    required String username,
    required String password,
    int port = 22,
  }) => BackendConfig(
        kind: BackendKind.ssh,
        host: host,
        username: username,
        password: password,
        port: port,
      );
}
