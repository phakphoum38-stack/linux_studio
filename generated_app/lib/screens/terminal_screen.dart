import 'package:flutter/material.dart';

import '../core/engine/pty_bridge.dart';
import '../core/engine/screen_buffer.dart';
import '../core/engine/ssh_bridge.dart';
import '../ui/terminal_view.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController controller = TextEditingController();

  late final ScreenBuffer buffer;
  late final SshBridge ssh;
  late final PtyBridge bridge;

  @override
  void initState() {
    super.initState();

    buffer = ScreenBuffer(
      rows: 24,
      cols: 80,
    );

    ssh = SshBridge();

    bridge = PtyBridge(
      ssh: ssh,
      buffer: buffer,
    );

    bridge.onRefresh = () {
      if (mounted) {
        setState(() {});
      }
    };

    bridge.start();
  }

  Future<void> connect() async {
    await ssh.connect(
      host: "192.168.1.10",
      username: "root",
      password: "1234",
      port: 22,
    );
  }

  void runCommand(String cmd) {
    if (cmd.trim().isEmpty) return;

    bridge.write(cmd);
    controller.clear();
  }

  @override
  void dispose() {
    bridge.kill();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TerminalView(
            screen: buffer,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: runCommand,
                decoration: const InputDecoration(
                  hintText: "Command...",
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                runCommand(controller.text);
              },
            ),
          ],
        ),
      ],
    );
  }
}
