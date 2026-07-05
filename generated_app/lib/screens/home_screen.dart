import 'package:flutter/material.dart';
import '../core/config/module_config.dart';

import 'terminal_screen.dart';
import 'file_manager_screen.dart';
import 'package_manager_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final pages = const [
    TerminalScreen(),
    FileManagerScreen(),
    PackageManagerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final modules = ModuleRegistry.enabledModules;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Linux Studio'),
      ),

      body: pages[index],

      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          setState(() {
            index = value;
          });
        },
        destinations: modules.map((m) {
          return NavigationDestination(
            icon: _iconFromName(m.icon),
            label: m.name,
          );
        }).toList(),
      ),
    );
  }

  Icon _iconFromName(String name) {
    switch (name) {
      case 'terminal':
        return const Icon(Icons.terminal);
      case 'folder':
        return const Icon(Icons.folder);
      case 'package':
        return const Icon(Icons.inventory_2);
      default:
        return const Icon(Icons.circle);
    }
  }
}
