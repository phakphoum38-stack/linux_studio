import 'package:flutter/material.dart';


import '../core/backend/backend_factory.dart';

import '../core/controller/terminal_controller.dart';

import '../core/engine/screen_buffer.dart';

import '../ui/terminal_view.dart';



class TerminalScreen extends StatefulWidget {


  const TerminalScreen({
    super.key,
  });



  @override
  State<TerminalScreen> createState()
      => _TerminalScreenState();

}





class _TerminalScreenState
    extends State<TerminalScreen> {


late ScreenBuffer buffer;


late TerminalController terminal;



final TextEditingController input =
    TextEditingController();







@override
void initState(){


super.initState();



buffer =
    ScreenBuffer(
      rows:24,
      cols:80,
    );





final backend =
    BackendFactory.create(
      mode:
        TerminalMode.local,
    );





terminal =
    TerminalController(

      buffer:buffer,

      backend:backend,

    );





terminal.onUpdate =
    (){

      if(mounted){

        setState((){});

      }

    };





terminal.start();



}









void send(
 String text,
){


terminal.write(
 "$text\n",
);


input.clear();


}








@override
void dispose(){


terminal.stop();


input.dispose();


super.dispose();


}









@override
Widget build(
 BuildContext context,
){


return Column(

children:[



Expanded(

child:

TerminalView(
 buffer:buffer,
),

),





TextField(

controller:input,


onSubmitted:send,


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
