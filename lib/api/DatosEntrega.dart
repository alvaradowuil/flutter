import 'dart:typed_data';

import 'package:app_pedidos/api/providers/OrderProvider.dart';
import 'package:app_pedidos/api/request_objects/SaveOrderDeliveredRequest.dart';
import 'package:app_pedidos/api/response_objects/GetOrderResponse.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_pedidos/FirmaPage.dart';
import 'dart:io';



TextEditingController nombrePersonaRecibeController =
new TextEditingController();
TextEditingController fechaEntregadoController = new TextEditingController();

TextEditingController observacionesController = new TextEditingController();

class DatosEntrega extends StatefulWidget {
static String tag = 'order-page';

final GetOrderResponse order;

const DatosEntrega({Key key, this.order}) : super(key: key);

@override
_DatosEntregaState createState() => _DatosEntregaState();
}

class _DatosEntregaState extends State<DatosEntrega> {


bool _validateNombreRecibe = false;

bool submitting = false;

void toggleSubmitState() {
setState(() {
  submitting = !submitting;
});
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

DateTime _date = DateTime.now();
TimeOfDay _time = TimeOfDay.now();

String observacionesDropDown = 'Personalmente';

Future<Null> _selectDate(BuildContext context) async {
final DateTime picked = await showDatePicker(
  context: context, 
  initialDate: _date, 
  firstDate: new DateTime(2019), 
  lastDate: new DateTime(2050)
  );

  if(picked != null && picked != _date) {
    print("Date selected: ${_date.toString()} ");
    setState(() {
      _date = picked;
    });
  }
}

Future<Null> _selectTime(BuildContext context) async {
final TimeOfDay picked = await showTimePicker(
  context: context,
  initialTime: _time
  );

  if(picked != null && picked != _time) {
    print("Date selected: ${_time.toString()} ");
    setState(() {
      _time = picked;
    });
  }
}

Future<String> sendData(SaveOrderDeliveredRequest saveOrderDeliveredRequest, funcionCallback) async {
return OrderProvider().saveOrderDelivered(saveOrderDeliveredRequest, funcionCallback );
}

Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

File _image;

Future getImage() async {
var image = await ImagePicker.pickImage(source: ImageSource.camera);
setState(() {
  _image = image;
});
}

ByteData _imgFirma;

_openFirmaPage(BuildContext context) async {
final resultFirmaPage = await Navigator.push(
  context, 
  MaterialPageRoute(builder: (context) => FirmaPage()));

if (resultFirmaPage != null){
  setState(() {
    _imgFirma = resultFirmaPage;
  });
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
  key: _scaffoldKey,
  appBar: AppBar(
    leading: new IconButton(
      icon: new Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Text('Pedido No. ' + widget.order.getNoPedido()),
    backgroundColor: Colors.green,
  ),
  body: new Container(
      child: Center(
    child: Container(
      padding: EdgeInsets.all(20),
      child: ListView(children: <Widget>[
        new Image(
          image: NetworkImage("https://fioriguate.com/images/pedidos/" +
              widget.order.getImagenRecoger()),
          width: 250,
          height: 250,
        ),
        new ListTile(
          title: Text('Fecha y hora de engrega'),
          subtitle: Text(_date.toString().substring(0,16)),
        ),
        Divider(),
        Center(child:Text("Paso 1:")),
        new ListTile(
          leading: const Icon(Icons.content_paste),
          title: new TextField(
              controller: nombrePersonaRecibeController,
              decoration:
                  new InputDecoration(
                    hintText: "Nombre de quien recibe", 
                  errorText: _validateNombreRecibe ? 'Value Can\'t Be Empty' : null,),
              keyboardType: TextInputType.text,
          )
        ),
        Divider(),
        Center(child:Text("Paso 2:"))
        ,
        Text('Persona que recibió:'),
         DropdownButton<String>(
          value: observacionesDropDown,
          onChanged: (String newValue) {
            setState(() {
              observacionesDropDown = newValue;
            });
          },
          items: <String>['Personalmente', 'Recepcionista', 'Garita/seguridad', 'Empleada doméstica', 'Otro']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Divider(),
        Center(child:Text("Paso 3:"))
        ,
            // Center(
            //   child: Center(
            //   child: _image == null
            //   ? FlatButton(
            //     onPressed: (){
            //       getImage();
            //     },
            //     child: new Row(children: <Widget>[
            //       new Icon(Icons.camera_enhance, color: Colors.red),
            //       Text("Tomar foto.")
            //     ],) 
                
            //   )
            //   : FlatButton(
            //     onPressed: (){
            //       getImage();
            //     },
            //     child: new Image.file(_image)),
            // )
            // ),
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
                  Text("Tomar foto")
                ],) )
      ),
    ),
    Center(
      child:((_image != null)? new Image.file(_image, width: 100): Text('Ninguna Foto seleccionada'))
      ),
            Divider(),
        Center(child:Text("Paso 4:"))
        ,
            // Center(
            //   child: Center(
              
            //   child: _imgFirma == null
            //   ? FlatButton(
            //     onPressed: (){
            //       _openFirmaPage(context);
            //     },
            //     child: new Row(children: <Widget>[
            //       new Icon(Icons.edit, color: Colors.red),
            //       Text("Ingresar firma.")
            //     ],)
            //   )
            //   : FlatButton(
            //     onPressed: (){
            //       _openFirmaPage(context);
            //     },
            //     child: Image.memory(_imgFirma.buffer.asUint8List())),
            // ),
            // ),

            new ListTile(
      title: new RaisedButton(
        onPressed: (){
          _openFirmaPage(context);
        },
        color: Colors.green,
        splashColor: Colors.white,
        textColor: Colors.white,
        child: Center( child: new Row(children: <Widget>[
                  new Icon(Icons.camera_enhance, color: Colors.white),
                  Text("Ingresar firma")
                ],) )
      ),
    ),
    Center(
      child:((_imgFirma != null)? new Image.memory(_imgFirma.buffer.asUint8List(), width: 100,): Text('Ninguna Foto seleccionada'))
      ),

        /*Center(
          child: _image == null
              ? Text('No image selected.')
              : Image.file(_image),
        ),*/
        /*Center(
          child: _imgFirma == null 
          ? Text('') 
          : Image.memory(_imgFirma.buffer.asUint8List())
        ),*/
        /*new RaisedButton(
          onPressed: () {
              _openFirmaPage(context);
          },
          color: Colors.green,
          splashColor: Colors.white,
          textColor: Colors.white,
          child: const Text('Ingresar Firma'),
        ),*/
        
        

        /*new RaisedButton(
          onPressed: () {
            getImage();
          },
          color: Colors.green,
          splashColor: Colors.white,
          textColor: Colors.white,
          child: const Text("Seleccionar foto"),
        ),*/
        Divider(),
        Center(child:Text("Paso 5:"))
        ,
        Center(
          child: !submitting 
          ? new RaisedButton(
          onPressed: () {
            if (nombrePersonaRecibeController.text.isEmpty){
              _showSnackBar(context, 'Debe ingresar nombre de quien recibe');
            } else if (_image == null){
              _showSnackBar(context, 'Debe tomar una foto de entrega');
            } else if (_imgFirma == null){
              _showSnackBar(context, 'El cliente debe ingresar su firma');
            } else {
              toggleSubmitState();
            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text("Espere un momento se está subiendo la imagen..."),
                                  duration: Duration(seconds: 3),
                                ));
            sendData(
              SaveOrderDeliveredRequest(
                nombrePersonaRecibeController.text,
                _date.toString(),
                widget.order.getNoPedido(),
                _image,
                observacionesDropDown,
                _imgFirma
              ), ([bool res, String mensaje]){
                toggleSubmitState();
                if(res){
                  _clearFormData();
                  Navigator.pop(context, true);      
                } else {
                      _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(mensaje),
                                  duration: Duration(seconds: 3),
                                ));
                }
              }
            );
          }
          },
          color: Colors.green,
          splashColor: Colors.white,
          textColor: Colors.white,
          child: const Text("GUARDAR DATOS"),
        )
          
                    : const Center(child: const CircularProgressIndicator()),
                  ),
      ]),
    ),
  )),
);
}

_showSnackBar(BuildContext context, String message){
  _scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
}

  _clearFormData() {
    setState(() {
      nombrePersonaRecibeController.text = '';
      observacionesController.text = '';
      _image = null;
      _imgFirma = null;
    });
  }

}
