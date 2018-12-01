import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.green
    ),
      home: new GstCalculator()
  ));
}

class GstCalculator extends StatelessWidget {
  double billAmount = 0.0;
  double gstPercentage = 0.0;
GstCalculator();
  @override
  Widget build(BuildContext context) {
  
    TextField billAmountField = new TextField(
        decoration: new InputDecoration(
            labelText: "Bill amount(\$)"),
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          try {
            billAmount = double.parse(value.toString());
          } catch (exception) {
            billAmount = 0.0;

          }
        }
    );
    RaisedButton calculateButton = new RaisedButton(
        child: new Text("Calculate"),
        onPressed: () {
          
          double calculatedGst = billAmount * gstPercentage / 100.0;
          double total = billAmount + calculatedGst;


          AlertDialog dialog = new AlertDialog(
              content: new Text("GST Rs: $calculatedGst \n\n"
                  "Total Rs.: $total")
          );


          showDialog(context: context, child: dialog);
        }
    );

    TextField gstPercentageField = new TextField(
        decoration: new InputDecoration(
            labelText: "GST %",hintText: "15"),
        keyboardType: TextInputType.number,
        onChanged: (String value) {
      try {
        gstPercentage = double.parse(value.toString());
      } catch (exception) {
        gstPercentage = 0.0;
      }
    }
    );

Container container = new Container(
    padding: const EdgeInsets.all(16.0),
    child: new Column(
        children: [ billAmountField,
        gstPercentageField,
        calculateButton ]
    )

);
AppBar appBar = new AppBar(title: new Text("GST Calculator"),centerTitle: true,);
Scaffold scaffold = new Scaffold(appBar: appBar,body: container);
return scaffold;

    }
}