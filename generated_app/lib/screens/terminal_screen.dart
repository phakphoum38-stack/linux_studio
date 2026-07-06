import 'package:flutter/material.dart';
import '../core/engine/pty_bridge.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<String> output = [];

  final PtyBridge bridge = PtyBridge();

  @override
  void initState() {
    super.initState();

    bridge.onOutput = (data) {
      setState(() {
        output.add(data);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
            scrollController.position.maxScrollExtent,
          );
        }
      });
    };

    bridge.start("localhost", 22);
  }

  void runCommand(String cmd) {
    if (cmd.trim().isEmpty) return;

    setState(() {
      output.add("\$ $cmd");
    });

    bridge.write(cmd);
    controller.clear();
  }

  @override
  void dispose() {
    bridge.kill();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              controller: scrollController,
              itemCount: output.length,
              itemBuilder: (context, index) {
                return SelectableText(
                  output[index],
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                );
              },
            ),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter command...",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black87,
                  border: InputBorder.none,
                ),
                onSubmitted: runCommand,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
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
