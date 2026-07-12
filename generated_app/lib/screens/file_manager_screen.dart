import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  Directory? _directory;
  List<FileSystemEntity> _entries = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _openInitialDirectory();
  }

  Future<void> _openInitialDirectory() async {
    try {
      await _load(await getApplicationDocumentsDirectory());
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  Future<void> _load(Directory directory) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (!await directory.exists()) await directory.create(recursive: true);
      final entries = await directory.list().toList();
      entries.sort((a, b) {
        if (a is Directory && b is! Directory) return -1;
        if (a is! Directory && b is Directory) return 1;
        return path.basename(a.path).toLowerCase().compareTo(
              path.basename(b.path).toLowerCase(),
            );
      });
      if (!mounted) return;
      setState(() {
        _directory = directory;
        _entries = entries;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _importFile() async {
    final result = await FilePicker.platform.pickFiles();
    final sourcePath = result?.files.single.path;
    if (sourcePath == null || _directory == null) return;
    final destination = path.join(_directory!.path, path.basename(sourcePath));
    await File(sourcePath).copy(destination);
    await _load(_directory!);
  }

  Future<void> _createFolder() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New folder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Folder name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || _directory == null) return;
    await Directory(path.join(_directory!.path, name)).create();
    await _load(_directory!);
  }

  Future<void> _openFile(File file) async {
    String content;
    try {
      content = await file.readAsString();
    } catch (_) {
      content = 'Binary file (${await file.length()} bytes)';
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(path.basename(file.path)),
        content: SizedBox(
          width: 700,
          child: SingleChildScrollView(
            child: SelectableText(content.isEmpty ? '(empty file)' : content),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Row(
            children: [
              IconButton(
                tooltip: 'Up',
                onPressed: _directory?.parent.path == _directory?.path
                    ? null
                    : () => _load(_directory!.parent),
                icon: const Icon(Icons.arrow_upward),
              ),
              Expanded(
                child: Text(
                  _directory?.path ?? 'Loading…',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(onPressed: _createFolder, tooltip: 'New folder', icon: const Icon(Icons.create_new_folder)),
              IconButton(onPressed: _importFile, tooltip: 'Import file', icon: const Icon(Icons.file_upload)),
              IconButton(
                onPressed: _directory == null ? null : () => _load(_directory!),
                tooltip: 'Refresh',
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(child: Text('File manager error:\n$_error'))
                  : _entries.isEmpty
                      ? const Center(child: Text('This folder is empty'))
                      : ListView.builder(
                          itemCount: _entries.length,
                          itemBuilder: (context, index) {
                            final entry = _entries[index];
                            final isDirectory = entry is Directory;
                            return ListTile(
                              leading: Icon(isDirectory ? Icons.folder : Icons.insert_drive_file),
                              title: Text(path.basename(entry.path)),
                              onTap: () => isDirectory ? _load(entry) : _openFile(entry as File),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
