class ScrollbackBuffer {


  final int maxLines;


  final List<String> _lines = [];



  ScrollbackBuffer({
    this.maxLines = 10000,
  });





  void add(String text){

    final lines =
        text.split('\n');


    for(final line in lines){

      _lines.add(line);


      if(_lines.length > maxLines){

        _lines.removeAt(0);

      }

    }

  }







  int get length =>
      _lines.length;






  String line(int index){

    if(index < 0 ||
       index >= _lines.length){

      return '';

    }


    return _lines[index];

  }







  List<String> get lines =>
      List.unmodifiable(
        _lines,
      );







  void clear(){

    _lines.clear();

  }

}
