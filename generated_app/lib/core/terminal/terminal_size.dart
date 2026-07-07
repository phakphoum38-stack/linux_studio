class TerminalSize {

  final int cols;
  final int rows;


  const TerminalSize({
    required this.cols,
    required this.rows,
  });


  @override
  String toString(){
    return "$cols x $rows";
  }

}
