import 'package:flutter/material.dart';

import 'screen_buffer.dart';



class TerminalView extends StatefulWidget {



  final ScreenBuffer buffer;



  final VoidCallback? onUpdate;



  const TerminalView({

    super.key,

    required this.buffer,

    this.onUpdate,

  });







  @override

  State<TerminalView> createState()

      => _TerminalViewState();

}









class _TerminalViewState

    extends State<TerminalView> {



  @override

  void initState()

  {

    super.initState();




    widget.buffer.cursor.startBlink(

      refresh,

    );


  }









  void refresh()

  {


    if(mounted)

    {

      setState(() {});

    }


    widget.onUpdate?.call();


  }









  @override

  void dispose()

  {


    widget.buffer.cursor.stopBlink();



    super.dispose();


  }









  Color ansiColor(int code)

  {


    const colors =

    {

      30: Colors.black,

      31: Colors.red,

      32: Colors.green,

      33: Colors.yellow,

      34: Colors.blue,

      35: Colors.purple,

      36: Colors.cyan,

      37: Colors.white,

    };



    return colors[code]

        ?? Colors.white;


  }









  Color ansiBackground(int code)

  {


    const colors =

    {

      40: Colors.black,

      41: Colors.red,

      42: Colors.green,

      43: Colors.yellow,

      44: Colors.blue,

      45: Colors.purple,

      46: Colors.cyan,

      47: Colors.white,

    };



    return colors[code]

        ?? Colors.transparent;


  }









  @override

  Widget build(BuildContext context)

  {


    final screen =

        widget.buffer;







    return RepaintBoundary(

      child: Container(

        color: Colors.black,

        padding:

            const EdgeInsets.all(8),

        child: Column(

          crossAxisAlignment:

              CrossAxisAlignment.start,

          children:

              List.generate(

            screen.rows,

            (row)

            {


              return Row(

                children:

                    List.generate(

                  screen.cols,

                  (col)

                  {


                    final cell =

                        screen.buffer[row][col];





                    final cursor =

                        screen.cursor.visible &&

                        screen.cursor.row == row &&

                        screen.cursor.col == col;






                    return SizedBox(

                      width: 10,

                      height: 18,

                      child: ColoredBox(

                        color:

                            cursor

                            ? Colors.white

                            :

                            ansiBackground(

                              cell.background,

                            ),

                        child: Center(

                          child: Text(

                            cell.char,

                            style:

                                TextStyle(

                              fontFamily:

                                  'monospace',

                              color:

                                  cursor

                                  ? Colors.black

                                  :

                                  ansiColor(

                                    cell.foreground,

                                  ),

                              fontWeight:

                                  cell.bold

                                  ?

                                  FontWeight.bold

                                  :

                                  FontWeight.normal,

                              fontStyle:

                                  cell.italic

                                  ?

                                  FontStyle.italic

                                  :

                                  FontStyle.normal,

                              decoration:

                                  cell.underline

                                  ?

                                  TextDecoration.underline

                                  :

                                  TextDecoration.none,

                              fontSize: 14,

                              height: 1,

                            ),

                          ),

                        ),

                      ),

                    );


                  },

                ),

              );


            },

          ),

        ),

      ),

    );


  }



}