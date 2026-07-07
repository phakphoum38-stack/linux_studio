class TerminalKeyboard {


  static String handle(
    String key,
  ){

    switch(key){


      case "ArrowUp":
        return "\x1b[A";


      case "ArrowDown":
        return "\x1b[B";


      case "ArrowRight":
        return "\x1b[C";


      case "ArrowLeft":
        return "\x1b[D";



      case "Home":
        return "\x1b[H";


      case "End":
        return "\x1b[F";


      case "Delete":
        return "\x1b[3~";



      case "Backspace":
        return "\x7f";


      case "Enter":
        return "\r";


      case "Tab":
        return "\t";



      case "CTRL+C":
        return "\x03";


      case "CTRL+D":
        return "\x04";


      case "CTRL+Z":
        return "\x1a";



      default:

        return key;

    }

  }



}
