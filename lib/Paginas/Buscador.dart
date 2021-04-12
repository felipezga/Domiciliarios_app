import 'package:flutter/material.dart';

class Buscador extends StatelessWidget{
  const Buscador({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            /*content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),*/
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  //setState(() {
                    Navigator.pop(context);
                  //});
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  //setState(() {
                    //codeDialog = valueText;
                    Navigator.pop(context);
                  //});
                },
              ),
            ],
          );
        });

  }
}