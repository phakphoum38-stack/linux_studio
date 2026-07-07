import 'dart:async';


class CursorPosition {

  int row = 0;
  int col = 0;


  bool visible = true;


  bool blinking = false;


  Timer? _timer;



  void reset(){

    row = 0;
    col = 0;

  }





  void startBlink(
    Function refresh,
  ){

    if(blinking)
      return;


    blinking = true;


    _timer =
        Timer.periodic(
          const Duration(
            milliseconds: 500,
          ),
          (_) {

            visible = !visible;

            refresh();

          },
        );

  }







  void stopBlink(){

    _timer?.cancel();

    _timer = null;

    blinking = false;

    visible = true;

  }







  void move(
    int r,
    int c,
  ){

    row=r;
    col=c;


    visible=true;

  }

}
