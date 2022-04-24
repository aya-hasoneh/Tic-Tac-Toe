import 'package:flutter/material.dart';
import 'package:game_x_and_o/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'X/O Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Player {
  static const none = ' ';
  static const X = 'X';
  static const O = 'O';
}

class _MyHomePageState extends State<MyHomePage> {
  static final countMatrix = 3;
  static final double size = 92;
  String lastMove = Player.none;
  late List<List<String>> matrix;
  @override
  void initState() {
    setEmptyFeilds();
    super.initState();
  }

  void setEmptyFeilds() => setState(() => matrix = List.generate(
      countMatrix,
      (_) => List.generate(
            countMatrix,
            (_) => Player.none,
          )));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: getBackGroundColor(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(widget.title,style: TextStyle(color: Colors.black),),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
          )),
    );
  }

  Widget buildRow(int x) {
    final values = matrix[x];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(values, (y, value) => buildFeild(x, y)),
    );
  }

  Color getFeildColor(String value) {
    switch (value) {
      case Player.O:
        return Colors.purple;
      case Player.X:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  Widget buildFeild(int x, int y) {
    final value = matrix[x][y];
    final color = getFeildColor(value);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: color, minimumSize: Size(size, size)),
          onPressed: () => selectFeild(value, x, y),
          child: Text(value, style: const TextStyle(fontSize: 32))),
    );
  }

  Color getBackGroundColor() {
    final thisMove = lastMove == Player.X ? Player.O : Player.X;
    return getFeildColor(thisMove).withOpacity(0.5);
  }

  void selectFeild(String value, int x, int y) {
    if (value == Player.none) {
      final newValue = lastMove == Player.X ? Player.O : Player.X;
      setState(() {
        lastMove = newValue;
        matrix[x][y] = newValue;
      });
      if (isWinner(x, y)) {
        showEndDialog('Player $newValue Won');
      } else if (isEnd()) {
        showEndDialog('Undecided Game');
      }
    }
  }

  bool isEnd() =>
      matrix.every((values) => values.every((value) => value != Player.none));
  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final Player = matrix[x][y];
    final counter = countMatrix;
    for (int i = 0; i < counter; i++) {
      if (matrix[x][i] == Player) col++;
      if (matrix[i][y] == Player) row++;
      if (matrix[i][i] == Player) diag++;
      if (matrix[i][counter - i - 1] == Player) rdiag++;
    }
    return row == counter ||
        col == counter ||
        diag == counter ||
        rdiag == counter;
  }

  Future showEndDialog(String title) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: const Text("Press to restart the game"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    setEmptyFeilds();
                    Navigator.pop(context);
                  },
                  child: const Text("restart"))
            ],
          ));
}
