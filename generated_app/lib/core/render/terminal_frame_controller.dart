import '../engine/screen_buffer.dart';
import 'dirty_tracker.dart';


class TerminalFrameController {

  final DirtyTracker dirty =
      DirtyTracker();


  ScreenBuffer? buffer;

  ScreenBuffer? previous;



  void attach(
    ScreenBuffer screen,
  ) {

    buffer = screen;

    previous = ScreenBuffer(
      rows: screen.rows,
      cols: screen.cols,
    );

  }



  bool shouldRepaint() {

    return dirty.dirtyCells.isNotEmpty;
  }




  void commitFrame() {

    if (buffer == null ||
        previous == null) {
      return;
    }


    for (int r = 0;
        r < buffer!.rows;
        r++) {


      for (int c = 0;
          c < buffer!.cols;
          c++) {


        previous!
            .buffer[r][c] =
            buffer!
            .buffer[r][c]
            .copy();

      }
    }


    dirty.clear();
  }
}
