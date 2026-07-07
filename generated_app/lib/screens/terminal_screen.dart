import 'package:flutter/material.dart';

import '../core/engine/screen_buffer.dart';
import '../core/engine/ssh_bridge.dart';
import '../core/engine/pty_bridge.dart';
import '../ui/terminal_view.dart';



class TerminalScreen extends StatefulWidget {

  const TerminalScreen({
    super.key,
  });



  @override
  State<TerminalScreen> createState() =>
      _TerminalScreenState();
}




class _TerminalScreenState
    extends State<TerminalScreen> {



  late ScreenBuffer buffer;

  late SshBridge ssh;

  late PtyBridge bridge;



  final TextEditingController controller =
      TextEditingController();



  @override
  void initState() {

    super.initState();



    buffer =
        ScreenBuffer(
          rows: 24,
          cols: 80,
        );



    ssh =
        SshBridge();



    bridge =
        PtyBridge(
          ssh: ssh,
          buffer: buffer,
        );



    bridge.onRefresh =
        () {

      if (mounted) {

        setState(() {});
      }
    };



    bridge.start();
  }




  void send(
    String text,
  ) {

    bridge.write(text);

    controller.clear();
  }




  @override
  void dispose() {

    bridge.kill();

    controller.dispose();

    super.dispose();
  }




  @override
  Widget build(
    BuildContext context,
  ) {


    return Column(

      children: [


        Expanded(

          child: TerminalView(
            buffer: buffer,
          ),
        ),



        TextField(

          controller: controller,


          onSubmitted: send,


          style: const TextStyle(
            color: Colors.white,
          ),


          decoration:
              const InputDecoration(
                hintText:
                    "Command",
              ),
        ),
      ],
    );
  }
}
