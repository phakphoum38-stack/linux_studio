import 'plugin.dart';


class PluginManager {

  final List<TerminalPlugin> plugins = [];



  /// Register plugin

  void register(
    TerminalPlugin plugin,
  ) {

    if (plugins.contains(plugin)) {
      return;
    }


    plugins.add(plugin);

    plugin.onInit();
  }




  /// Remove plugin

  void unregister(
    TerminalPlugin plugin,
  ) {

    plugin.dispose();

    plugins.remove(plugin);
  }




  /// Send terminal data

  void emitData(
    String data,
  ) {

    for (final plugin in plugins) {

      plugin.onData(
        data,
      );
    }
  }




  /// Send VT100 command

  void emitCommand(
    String command,
    List<int> args,
  ) {

    for (final plugin in plugins) {

      plugin.onCommand(
        command,
        args,
      );
    }
  }




  /// Dispose all plugins

  void dispose() {

    for (final plugin in plugins) {

      plugin.dispose();
    }


    plugins.clear();
  }
}
