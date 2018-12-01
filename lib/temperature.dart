import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Temperature(),
    ));

class Temperature extends StatefulWidget {
  Temperature();
  @override
  TempState createState() => TempState();
}

class TempState extends State<Temperature> {
  double input;
  double output;
  bool fOrC;

  @override
  void initState() {
    super.initState();
    input = 0.0;
    output = 0.0;
    fOrC = true;
  }

  @override
  Widget build(BuildContext context) {
    TextField inputField = TextField(
      keyboardType: TextInputType.number,
      onChanged: (str) {
        try {
          input = double.parse(str);
        } catch (e) {
          input = 0.0;
        }
      },
      decoration: InputDecoration(
        labelText:
            "Input a Value in ${fOrC == false ? "Fahrenheit" : "Celsius"}",
      ),
      textAlign: TextAlign.center,
    );

    AppBar appBar = AppBar(
      title: Text("Temperature"),
      centerTitle: true,
    );

    Container tempSwitch = Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          Text("F"),
          Radio<bool>(
              groupValue: fOrC,
              value: false,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              }),
          Text("C"),
          Radio<bool>(
              groupValue: fOrC,
              value: true,
              onChanged: (v) {
                setState(() {
                  fOrC = v;
                });
              }),
        ],
      ),
    );

    Container calcBtn = Container(
      child: MaterialButton(
        color: Colors.orange,
        child: Text("CONVERT"),
        onPressed: () {
          setState(() {
            fOrC == false
                ? output = (input - 32) * (5 / 9)
                : output = (input * 9 / 5) + 32;
          });
          AlertDialog dialog = AlertDialog(
            content: fOrC == false
                ? Text(
                    "${input.toStringAsFixed(2)} F ===>> ${output.toStringAsFixed(2)} C")
                : Text(
                    "${input.toStringAsFixed(2)} C ===>> ${output.toStringAsFixed(2)} F"),
          );
          showDialog(context: context, child: dialog);
        },
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            inputField,
            tempSwitch,
            calcBtn,
          ],
        ),
      ),
    );
  }
}