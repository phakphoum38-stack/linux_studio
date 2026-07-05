import 'package:flutter/material.dart';
import '../core/engine/terminal_engine.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final engine = TerminalEngine();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    engine.start(() {
      setState(() {});
    });
  }

  Color _mapColor(String c) {
    switch (c) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'cyan':
        return Colors.cyan;
      default:
        return Colors.greenAccent;
    }
  }

  void run(String cmd) {
    engine.write(cmd);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final buffer = engine.buffer;

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: ListView.builder(
              itemCount: buffer.grid.length,
              itemBuilder: (_, r) {
                final row = buffer.grid[r];

                return Row(
                  children: row.map((cell) {
                    return Text(
                      cell.char,
                      style: TextStyle(
                        color: _mapColor(cell.color),
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
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
                onSubmitted: run,
                decoration: const InputDecoration(
                  hintText: 'bash...',
                  filled: true,
                  fillColor: Colors.black87,
                ),
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
bool showCursor = true;
@override
void initState() {
  super.initState();

  engine.start(() {
    setState(() {});
  });

  Future.periodic(const Duration(milliseconds: 500), (timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }

    setState(() {
      showCursor = !showCursor;
    });
  });
}
itemBuilder: (_, r) {
  final row = engine.buffer.grid;

  return Row(
    children: List.generate(row[r].length, (c) {
      final cell = row[r][c];

      final isCursor =
          r == engine.buffer.cursor.row &&
          c == engine.buffer.cursor.col;

      return Stack(
        children: [
          Text(
            cell.char,
            style: TextStyle(
              color: _mapColor(cell.color),
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),

          if (isCursor && showCursor)
            Container(
              width: 8,
              height: 14,
              color: Colors.greenAccent,
            ),
        ],
      );
    }),
  );
}

