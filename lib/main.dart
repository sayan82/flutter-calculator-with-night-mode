import 'dart:async';
import 'package:calculator/GST.dart';
import 'package:calculator/temperature.dart';
import 'package:flutter/material.dart';
import 'other.dart';

void main() => runApp(new MyApp());

const appName = 'Commerce Calc';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.darkThemeEnabled,
      initialData: false,
      builder: (context,snapshot) => new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: snapshot.data?ThemeData.dark():ThemeData.light(),
        home: new Homepage(snapshot.data),
        routes: <String, WidgetBuilder>{
          "/a" : (BuildContext context) => new GstCalculator(),
          "/b" :  (BuildContext context) => new Temperature(),
      }),
    );
  }
}

class Homepage extends StatelessWidget {
  bool darkThemeEnabled;
  Homepage(this.darkThemeEnabled);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        
        title: Text("Commerce Calc"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: new Text("Sayan"),
              accountEmail: new Text("example@gmail.com"),
              currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.lime,
              child: new Text("S"),
              ),
              otherAccountsPictures: <Widget>[
                new CircleAvatar(
                  backgroundColor: Colors.pink,
              child: new Text("Raj"),
                )
              ],
            ),
            new ListTile(
             title: new Text("Night Mode",style: TextStyle(fontWeight: FontWeight.bold),),
             trailing: Switch(
               value: darkThemeEnabled,
               onChanged: bloc.changeTheme,
             ),
            ),
            new Divider(),
             new ListTile(
             title: new Text("GST",style: TextStyle(fontWeight: FontWeight.bold),),
             trailing: new Icon(Icons.monetization_on),
             onTap: ()=> Navigator.of(context).pushNamed("/a"),
            ),
            new Divider(),
             new ListTile(
             title: new Text("Temperature",style: TextStyle(fontWeight: FontWeight.bold),),
             trailing: new Icon(Icons.wb_sunny),
             onTap: ()=> Navigator.of(context).pushNamed("/b"),
            ),
          ],
        ),
      ),
      body: new Column(
        children: <Widget>[
          new Display(),
          new Keyboard(),
        ],
      ),
    );
  }
}

var _displayState = new DisplayState();

class Display extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _displayState;
  }
}

class DisplayState extends State<Display> {
  var _expression = '';
  var _result = '';

  @override
  Widget build(BuildContext context) {
    var views = <Widget>[
      new Expanded(
          flex: 1,
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Text(
                    _expression,
                    textAlign: TextAlign.right,
                    style: new TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ))
            ],
          )),
    ];

    if (_result.isNotEmpty) {
      views.add(new Expanded(
          flex: 1,
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Text(
                    _result,
                    textAlign: TextAlign.right,
                    style: new TextStyle(
                      fontSize: 35.0,
                      color: Colors.white,
                    ),
                  ))
            ],
          )),
      );
    }

    return new Expanded(
        flex: 2,
        child: new Container(
          color: Theme
              .of(context)
              .primaryColor,
          padding: const EdgeInsets.all(16.0),
          child: new Column(
            children: views,
          ),
        ));
  }
}

void _addKey(String key) {
  var _expr = _displayState._expression;
  var _result = '';
  if (_displayState._result.isNotEmpty) {
    _expr = '';
    _result = '';
  }

  if (operators.contains(key)) {
    // Handle as an operator
    if (_expr.length > 0 && operators.contains(_expr[_expr.length - 1])) {
      _expr = _expr.substring(0, _expr.length - 1);
    }
    _expr += key;
  } else if (digits.contains(key)) {
    // Handle as an operand
    _expr += key;
  } else if (key == 'C') {
    // Delete last character
    if (_expr.length > 0) {
      _expr = _expr.substring(0, _expr.length - 1);
    }
  } else if (key == '=') {
    try {
      var parser = const Parser();
      _result = parser.parseExpression(_expr).toString();
    } on Error {
      _result = 'Error';
    }
  }
  // ignore: invalid_use_of_protected_member
  _displayState.setState(() {
    _displayState._expression = _expr;
    _displayState._result = _result;
  });
}

class Keyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
        flex: 4,
        child: new Center(
            child:
            new AspectRatio(
              aspectRatio: 1.05, // To center the GridView
              child: new GridView.count(
                crossAxisCount: 5,
                childAspectRatio: .89,
                padding: const EdgeInsets.all(2.0),
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 3.0,
                children: <String>[
                  // @formatter:off
                  'C','0', '00', '000', '/',
                  '7', '8', '9', '√', '*',
                  '4', '5', '6', '%', '-',
                  '1', '2', '3', '=', '+',
                  // @formatter:on
                ].map((key) {
                  return new GridTile(
                    child: new KeyboardKey(key),
                  );
                }).toList(),
              ),
            )
        ));
  }
}

class KeyboardKey extends StatelessWidget {
  KeyboardKey(this._keyValue);

  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(
        _keyValue,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
          color: Colors.lightGreen,
        ),
      ),
      color: Theme
          .of(context)
          .scaffoldBackgroundColor,
      onPressed: () {
        _addKey(_keyValue);
      },
    );
  }
}

class Bloc{
  final _themeController = StreamController<bool>();
   get changeTheme => _themeController.sink.add;
   get darkThemeEnabled => _themeController.stream;
}
final bloc = Bloc();