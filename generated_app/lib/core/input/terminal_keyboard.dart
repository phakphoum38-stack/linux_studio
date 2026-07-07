class TerminalKeyboard {



  static String key(
    String name,
  ){


    switch(name){


      case "UP":
        return "\x1b[A";


      case "DOWN":
        return "\x1b[B";


      case "RIGHT":
        return "\x1b[C";


      case "LEFT":
        return "\x1b[D";


      case "BACKSPACE":
        return "\x7f";


      case "ENTER":
        return "\r";


      case "TAB":
        return "\t";


      case "CTRL+C":
        return "\x03";


      case "CTRL+D":
        return "\x04";


      default:

        return name;

    }

  }


}
