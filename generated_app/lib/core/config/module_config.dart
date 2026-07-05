class ModuleConfig {
  final String name;
  final String icon;
  final bool enabled;

  const ModuleConfig({
    required this.name,
    required this.icon,
    this.enabled = true,
  });
}
class ModuleRegistry {
  static const List<ModuleConfig> modules = [
    ModuleConfig(name: 'Terminal', icon: 'terminal'),
    ModuleConfig(name: 'File Manager', icon: 'folder'),
    ModuleConfig(name: 'Package Manager', icon: 'package'),
  ];

  static List<ModuleConfig> get enabledModules =>
      modules.where((m) => m.enabled).toList();
}
