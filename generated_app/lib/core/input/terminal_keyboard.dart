class TerminalKeyboard {


  static String key(
    String name,
  ) {


    switch(name.toUpperCase()) {


      // Cursor

      case "UP":
        return "\x1b[A";


      case "DOWN":
        return "\x1b[B";


      case "RIGHT":
        return "\x1b[C";


      case "LEFT":
        return "\x1b[D";



      // Navigation

      case "HOME":
        return "\x1b[H";


      case "END":
        return "\x1b[F";


      case "PAGE_UP":
        return "\x1b[5~";


      case "PAGE_DOWN":
        return "\x1b[6~";



      // Editing

      case "BACKSPACE":
        return "\x7f";


      case "DELETE":
        return "\x1b[3~";


      case "INSERT":
        return "\x1b[2~";



      // Control

      case "ENTER":
        return "\r";


      case "TAB":
        return "\t";


      case "ESC":
        return "\x1b";



      case "CTRL+A":
        return "\x01";


      case "CTRL+C":
        return "\x03";


      case "CTRL+D":
        return "\x04";


      case "CTRL+E":
        return "\x05";


      case "CTRL+L":
        return "\x0c";


      case "CTRL+Z":
        return "\x1a";



      // Function keys

      case "F1":
        return "\x1bOP";


      case "F2":
        return "\x1bOQ";


      case "F3":
        return "\x1bOR";


      case "F4":
        return "\x1bOS";


      case "F5":
        return "\x1b[15~";


      case "F6":
        return "\x1b[17~";


      case "F7":
        return "\x1b[18~";


      case "F8":
        return "\x1b[19~";


      case "F9":
        return "\x1b[20~";


      case "F10":
        return "\x1b[21~";


      case "F11":
        return "\x1b[23~";


      case "F12":
        return "\x1b[24~";



      default:

        return name;

    }

  }





  static String ctrl(
    String char,
  ) {

    if(char.isEmpty){
      return '';
    }


    final code =
        char.toUpperCase().codeUnitAt(0)
        - 64;


    if(code < 1 || code > 26){
      return char;
    }


    return String.fromCharCode(code);

  }



}
