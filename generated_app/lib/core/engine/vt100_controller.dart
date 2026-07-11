import 'ansi_csi_parser.dart';

import 'screen_buffer.dart';

import 'vt100_state_machine.dart';





class VT100Controller {



  final VT100StateMachine machine;









  VT100Controller({

    ScreenBuffer? buffer,

  })

      :

        machine =

            VT100StateMachine(

              buffer,

            );









  void handle(

    AnsiEvent event,

  )

  {


    machine.handle(

      event,

    );


  }









  void execute(

    String command,

    List<int> args,

  )

  {


    machine.execute(

      command,

      args,

    );


  }









  ScreenBuffer get buffer =>

      machine.buffer;









  int get cursorRow =>

      machine.cursorRow;









  int get cursorCol =>

      machine.cursorCol;









  bool get cursorVisible =>

      machine.cursorVisible;



}