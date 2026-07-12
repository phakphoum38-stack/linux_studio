import 'dart:io';

import 'package:flutter/material.dart';

class PackageManagerScreen extends StatefulWidget {
  const PackageManagerScreen({super.key});

  @override
  State<PackageManagerScreen> createState() => _PackageManagerScreenState();
}

class _PackageManagerScreenState extends State<PackageManagerScreen> {
  final _packageController = TextEditingController();
  String _output = 'Enter a package name to install, remove, or search.';
  bool _running = false;

  @override
  void dispose() {
    _packageController.dispose();
    super.dispose();
  }

  Future<void> _run(String action) async {
    final package = _packageController.text.trim();
    if (package.isEmpty || _running) return;
    setState(() {
      _running = true;
      _output = 'Running $action for $package…';
    });

    try {
      late String executable;
      late List<String> arguments;
      if (Platform.isWindows) {
        executable = 'winget';
        arguments = switch (action) {
          'install' => ['install', '--id', package, '--accept-source-agreements'],
          'remove' => ['uninstall', '--id', package],
          _ => ['search', package],
        };
      } else {
        executable = 'apk';
        arguments = switch (action) {
          'install' => ['add', package],
          'remove' => ['del', package],
          _ => ['search', package],
        };
      }
      final result = await Process.run(executable, arguments, runInShell: true);
      if (!mounted) return;
      setState(() {
        _output = '${result.stdout}${result.stderr}'.trim();
        if (_output.isEmpty) _output = 'Command completed with exit code ${result.exitCode}.';
      });
    } catch (error) {
      if (mounted) setState(() => _output = 'Package manager error:\n$error');
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _packageController,
            enabled: !_running,
            decoration: InputDecoration(
              labelText: Platform.isWindows ? 'Winget package ID' : 'Alpine package name',
              prefixIcon: const Icon(Icons.inventory_2),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _run('search'),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.icon(onPressed: _running ? null : () => _run('install'), icon: const Icon(Icons.download), label: const Text('Install')),
              OutlinedButton.icon(onPressed: _running ? null : () => _run('remove'), icon: const Icon(Icons.delete_outline), label: const Text('Remove')),
              OutlinedButton.icon(onPressed: _running ? null : () => _run('search'), icon: const Icon(Icons.search), label: const Text('Search')),
            ],
          ),
          const SizedBox(height: 16),
          if (_running) const LinearProgressIndicator(),
          const SizedBox(height: 8),
          Expanded(
            child: Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SelectableText(_output),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
