import 'terminal_engine.dart';
import 'screen_buffer.dart';
import 'selection_engine.dart';
import 'input_pipeline.dart';
import 'ansi_csi_parser.dart';



class TerminalController {


  final TerminalEngine engine;


  final InputPipeline input =
      InputPipeline();


  final SelectionEngine selection =
      SelectionEngine();



  late ScreenBuffer buffer;



  Function()? onUpdate;




  TerminalController({
    required this.engine,
  });







  Future<void> start(
    ScreenBuffer screen,
    Function() render,
  )
  async {


    buffer = screen;

    onUpdate = render;



    engine.onUpdate = () {

      onUpdate?.call();

    };



    await engine.start();


  }








  //
  // Send normal text
  //

  void send(
    String text,
  ){

    engine.write(
      text,
    );

  }







  //
  // Keyboard mapping
  //

  void sendKey(
    String key,
  ){


    switch(key){


      case 'ENTER':

        engine.write(
          '\r',
        );

        break;





      case 'BACKSPACE':

        engine.write(
          '\x7f',
        );

        break;






      case 'TAB':

        engine.write(
          '\t',
        );

        break;






      case 'CTRL_C':

        engine.write(
          '\x03',
        );

        break;






      case 'CTRL_D':

        engine.write(
          '\x04',
        );

        break;







      case 'ARROW_UP':

        engine.write(
          '\x1b[A',
        );

        break;






      case 'ARROW_DOWN':

        engine.write(
          '\x1b[B',
        );

        break;






      case 'ARROW_RIGHT':

        engine.write(
          '\x1b[C',
        );

        break;






      case 'ARROW_LEFT':

        engine.write(
          '\x1b[D',
        );

        break;






      case 'HOME':

        engine.write(
          '\x1b[H',
        );

        break;






      case 'END':

        engine.write(
          '\x1b[F',
        );

        break;






      default:

        engine.write(
          key,
        );

    }


  }









  void paste(
    String text,
  ){

    input.add(
      text,
    );


    final data =
        input.flush();


    if(data.isNotEmpty){

      engine.write(
        data,
      );

    }

  }








  void refresh(){

    onUpdate?.call();

  }








  Future<void> stop()
  async {

    await engine.kill();

  }

}
