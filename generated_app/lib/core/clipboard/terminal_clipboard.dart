import 'package:flutter/services.dart';


class TerminalClipboard {


  static Future<void> copy(
    String text,
  ) async {


    if(text.isEmpty){
      return;
    }


    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );

  }






  static Future<String> paste()
  async {


    final data =
        await Clipboard.getData(
          Clipboard.kTextPlain,
        );


    return data?.text ?? '';

  }


}
