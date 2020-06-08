import 'package:flutter/material.dart';

void main() {
  gridSetup(8);
  runApp(MaterialApp(
    home: ButtonPress()
  ));
}

void gridSetup(cells) {
  for (int i = 0; i < cells; i++) {
    _ButtonState button = new _ButtonState('$i', i, Colors.green);
    buttons.add(button);
  }
  buttons.add(_ButtonState('', cells, Colors.green[200]));
}

List<_ButtonState> buttons = [];

class ParentAccess extends InheritedWidget {
  final State parent;
  ParentAccess({Key key, this.parent, Widget child}) : super(key: key, child: child);

  static ParentAccess of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ParentAccess>();
  }

  @override
  bool updateShouldNotify(ParentAccess old) => parent != old.parent;
}

class Button extends StatefulWidget {
  final _ButtonState buttonState;
  Button(this.buttonState) : super(key: UniqueKey());

  @override
  _ButtonState createState() => buttonState;
}


class _ButtonState extends State<Button> {
  String number;
  int index;
  int position;
  Color colour;
  static int presses = 0;
  static int previousIndex = 0;

  _ButtonState(this.number, this.index, this.colour) {
    position = index;
  }

  int indexToColumn(i, scope) {
    int column = i ~/ scope;
    return column;
  }

  int indexToRow(i, scope) {
    int row = i % scope;
    return row;
  }

  int canMove(iFrom, iTo, scope) {
    int iFromColumn = indexToColumn(iFrom, scope);
    int iFromRow = indexToRow(iFrom, scope);
    int iToColumn = indexToColumn(iTo, scope);
    int iToRow = indexToRow(iTo, scope);

  if (iFromRow == iToRow || iFromColumn == iToColumn) {
    if ((iFromRow - iToRow).abs() == 1 || (iFromColumn - iToColumn).abs() == 1){
      if (iToRow < scope || iToColumn < scope) {
        return 1;
      }
    }
  }
  return 0;
  }

  void move(from, to) {
    if (canMove(buttons[from].position, buttons[to].position, 3) == 1) {
      if (buttons[from].number == '') {
        int temp = from;
        from = to;
        to = temp;
      }
      if((buttons[from].number != '' && buttons[to].number == ''))  {

        _ButtonState oFrom = buttons[from];
        _ButtonState oTo = buttons[to];

        oFrom.index = to;
        oTo.index = from;


        oTo.number = '$from';
        oFrom.number = ''; 
    
        buttons[from] = oTo;
        buttons[to] = oFrom;

      }
    }
    buttons[from].setState(() {});
    buttons[to].setState(() {});
  }
  
  Widget build(BuildContext context) {

    if(presses == 1) {
      colour = Colors.green[700];
    }
    else if(number == '') {
      colour = Colors.green[200];
    } else {
      colour = Colors.green;
    }
    return FlatButton(
      onPressed: () {
        if (presses == 1) {
          presses = 0;
          ParentAccess.of(context).parent.setState(() {
            move(previousIndex, index);
          });
        }
        else {
          presses = 1;
          previousIndex = index;
          setState(() {});
        }
      },
      child: Text(
          "$number",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 50.0,
          ),
        ),
      color: colour,
    );
  }
}

class ButtonPress extends StatefulWidget {
  @override
  _ButtonPressState createState() => _ButtonPressState();
}

class _ButtonPressState extends State<ButtonPress> {
  List<Button> populate() {
    List<Button> buttonsList = [];
    for (int i = 0; i < buttons.length; i++) {
      buttonsList.add(Button(buttons[i]));
    }
    return buttonsList;
  }
  @override
  void initState() {
    super.initState();
  }
  List<Button> buttonsList = [
    Button(buttons[0]),
    Button(buttons[1]),
    Button(buttons[2]),
    Button(buttons[3]),
    Button(buttons[4]),
    Button(buttons[5]),
    Button(buttons[6]),
    Button(buttons[7]),
    Button(buttons[8]),
  ];

  double gridAlignWidth;
  
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height < MediaQuery.of(context).size.width) {
      gridAlignWidth = MediaQuery.of(context).size.width * 0.45;
    } else {
      gridAlignWidth = MediaQuery.of(context).size.width;
    }

    Widget grid = GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.all(25.0),
        children: buttonsList,
        physics: NeverScrollableScrollPhysics(),
    );
    Scaffold scaffold = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Center(
          child: Text(
            "Slide Puzzle",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: grid,
          height: MediaQuery.of(context).size.height,
          width: gridAlignWidth,
        ),
      ),
    );
    return new ParentAccess(
      parent: this,
      child: scaffold,
    );
  }
}