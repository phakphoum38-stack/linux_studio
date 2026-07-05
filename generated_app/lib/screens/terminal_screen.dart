import 'package:flutter/material.dart';
import '../core/engine/terminal_engine.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final controller = TextEditingController();
  final engine = TerminalEngine();

  final List<String> output = [];

  @override
  void initState() {
    super.initState();

    engine.start((data) {
      setState(() {
        output.add(data);
      });
    });
  }

  void run(String cmd) {
    if (cmd.trim().isEmpty) return;

    setState(() {
      output.add('\$ $cmd');
    });

    engine.write(cmd);
    controller.clear();
  }

  @override
  void dispose() {
    engine.dispose();
    controller.dispose();
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
              itemCount: output.length,
              itemBuilder: (_, i) {
                return Text(
                  output[i],
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
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
                  hintText: 'bash command...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black87,
                ),
                onSubmitted: run,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => run(controller.text),
            ),
          ],
        ),
      ],
    );
  }
}
