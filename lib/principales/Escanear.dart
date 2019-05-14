// FirstScreen.dart

import 'package:app_pedidos/CodeScann.dart';
import 'package:app_pedidos/OrderPage.dart';
import 'package:app_pedidos/OrderResult.dart';
import 'package:app_pedidos/api/providers/OrderProvider.dart';
import 'package:app_pedidos/api/request_objects/GetOrderRequestAsignar.dart';
import 'package:app_pedidos/api/response_objects/GetOrderResponse.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/HomePage.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

TextEditingController codeController = new TextEditingController();

class Escanear extends StatefulWidget {

@override
_EscanearState createState() => _EscanearState();
}

class _EscanearState extends State<Escanear> {
bool submitting = false;

String _tomarFotoText = "      Tomar foto de pedido";

bool _validateCampoPedido = false;

void toggleSubmitState() {
  setState(() {
    submitting = !submitting;
  });
}

File _image;

Future getImage() async {
  var image = await ImagePicker.pickImage(source: ImageSource.camera);

  setState(() {
    _image = image;
    _tomarFotoText = "     Cambiar foto de pedido";
  });
}

@override
Widget build(BuildContext context) {
  return Container(
    child: Center(
      child: new Container(
padding: EdgeInsets.all(20),
child: new ListView(
  children: <Widget>[
    Center(
            child: !submitting
                ? new Container(color: Colors.grey,)
                : const Center(child: const CircularProgressIndicator()),
          ),
          Center(
      child: Text('Paso 1:'),
    )
    ,
    new ListTile(
      leading: const Icon(Icons.content_paste),
      title: new TextField(
        controller: codeController,
        decoration: new InputDecoration(hintText: "Ingrese número pedido",
        errorText: _validateCampoPedido ? 'Debe ingresar un número de pedido' : null,),
        keyboardType: TextInputType.text,
      )
    ),
    Divider(),
    Center(
      child: Text('Paso 2:'),
    ),

     new ListTile(
      title: new RaisedButton(
        onPressed: (){
          getImage();
        },
        color: Colors.green,
        splashColor: Colors.white,
        textColor: Colors.white,
        child: Center( child: new Row(children: <Widget>[
                  new Icon(Icons.camera_enhance, color: Colors.white),
                  Text(_tomarFotoText)
                ],) )
      ),
    ),
    Center(
      child:((_image != null)? new Image.file(_image, width: 100): Text('Ninguna Foto seleccionada'))
      ),
      Divider(),
    Center(
      child: Text("Paso 3:"),
    ),
    new ListTile(
      title: new RaisedButton(
        onPressed: (){
          if (codeController.text.isEmpty){
            _showSnackBar(context, 'Debe ingresar un codigo de pedido');
          } else if (_image == null){
            _showSnackBar(context, 'Debe capturar una foto para asignarse el pedido');
          } else {
            _assignMeOrder(context);
          }
        },
        color: Colors.green,
        splashColor: Colors.white,
        textColor: Colors.white,
        child: const Text('Asignarme pedido y mostrar datos'),
      ),
    )
  ],
)
),
    ),
  );
}

_assignMeOrder (BuildContext context){
  toggleSubmitState();
  _showSnackBar(context, 'Espere un momento mientras se sube la foto, por favor no cierre esta ventana...');
  OrderProvider().getOrderByCodeAsignar(
      GetOrderRequestAsignar(codeController.text, _image),
      ([bool respuesta, GetOrderResponse datos]){
        toggleSubmitState();
        if (respuesta){
          if(datos.getCliente() != null){
            _clearFormData();
            _showOrderPage(context, datos);
          } else {
            _showSnackBar(context, 'Lo sentimos no existe un pedido con ese número!');
          }
        } else {
          _showSnackBar(context, datos.getMensaje());
        }
    }
  );
}

_showOrderPage (BuildContext context, GetOrderResponse datos) async {
  OrderResult result = await Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (context) => OrderPage(order: datos, mostrarBotonEntregar: false)
    )
  ).then((value) {
                            setState(() {
                              //MyTabController.of(context).tabController.animateTo(1);
                              print("llegó al setstate");
                            });
                          });

  if (result != null){
    if (result.isResult()){
      _showSnackBar(context, result.getMessage());
    }
  }
}

_clearFormData() {
  setState(() {
    codeController.text = '';
    _image = null;
  });
}

_showSnackBar(BuildContext context, String message){
  Scaffold.of(context).showSnackBar(
    new SnackBar(
      content: new Text(message)));
}
}
