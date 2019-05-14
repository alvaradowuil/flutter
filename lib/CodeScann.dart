import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qrcode_reader/qrcode_reader.dart';

class CodeScann extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  final Map<String, dynamic> pluginParameters = {
  };

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> _barcodeString;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('QRCode Reader Example'),
        backgroundColor: Colors.green,
      ),
      body: new Center(
          child: new FutureBuilder<String>(
              future: new QRCodeReader()
                .setAutoFocusIntervalInMs(200)
                .setForceAutoFocus(true)
                .setTorchEnabled(true)
                .setHandlePermissions(true)
                .setExecuteAfterPermissionGranted(true)
                .scan(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                String qrCodeResult = 'Lectura cancelada';
                if (snapshot.data != null){
                  qrCodeResult = snapshot.data;
                  return RaisedButton(
                  color: Colors.green,
                  splashColor: Colors.white,
                  textColor: Colors.white,
                  child: Text(qrCodeResult),
                  onPressed: (){
                    
                    Navigator.pop(context, qrCodeResult);
                  });
                } else {
                  return RaisedButton(
                  color: Colors.green,
                  splashColor: Colors.white,
                  textColor: Colors.white,
                  child: Text('Validar $qrCodeResult'),
                  onPressed: (){
                    Navigator.pop(context);
                  });
                }
                
              })),
      
    );
  }
}
