import 'package:app_pedidos/OrderResult.dart';
import 'package:app_pedidos/api/response_objects/GetOrderResponse.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/api/DatosEntrega.dart';

class OrderPage extends StatefulWidget {
  static String tag = 'order-page';

  final GetOrderResponse order;
  final bool mostrarBotonEntregar;
  final String mensaje;

  const OrderPage({Key key, this.order, this.mostrarBotonEntregar = false, this.mensaje = ''}) : super(key: key);
  
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
@override
initState() {
  super.initState();
  
  if(widget.mensaje != '') {
  _showDialog();
  }

}

_showDialog() async {
        _showAlert(context);
    }


void _showAlert(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Alerta"),
            content: Text(widget.mensaje),
          )
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(
            context, 
            widget.mostrarBotonEntregar
            ? OrderResult(true, 'El pedido se le asignó correctamente!')
            : OrderResult(false, '')
          )
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
              image: (widget.order.getImagenRecoger() != '' && widget.order.getImagenRecoger() != null && widget.order.getImagenRecoger() != 'NULL')? NetworkImage("https://fioriguate.com/images/pedidos/" +
                  widget.order.getImagenRecoger()):NetworkImage("https://fioriguate.com/images/productos/" +
                  widget.order.getImagenes()[0]),
              width: 250,
              height: 250,
            ),
            ListTile(
                title: Text('Cliente'), subtitle: Text(widget.order.getCliente())),
            ListTile(title: Text('Para'), subtitle: Text(widget.order.getPara())),
            ListTile(
                title: Text('Telefono receptor'),
                subtitle: Text(widget.order.getTelefonoRecibe())),
            ListTile(
                title: Text('Dirección entrega'),
                subtitle: Text(widget.order.getDireccionEntrega())),
            ListTile(
                title: Text('Referencia'),
                subtitle: Text(widget.order.getReferencia())),
            ListTile(
                title: Text('Fecha entrega'),
                subtitle: Text(widget.order.getFechaEntrega())),
            widget.mostrarBotonEntregar ? RaisedButton(
              onPressed: () {
                _showDatosEntrega(context, widget.order);
              },
              color: Colors.green,
              splashColor: Colors.white,
              textColor: Colors.white,
              child: const Text('Entregar'),
            ): Text(''),
          //  RaisedButton(
          //     onPressed: () {
          //       _regresarAPendientes(context);
          //     },
          //     color: Colors.green,
          //     splashColor: Colors.white,
          //     textColor: Colors.white,
          //     child: const Text('Regresar a pendientes'),
          //   ),
          ]),
        ),
      )),
    );
  }

  _showDatosEntrega(BuildContext context, GetOrderResponse order) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DatosEntrega(order: widget.order))
    );

    if (result){
      Navigator.pop(context, widget.mostrarBotonEntregar
        ? OrderResult(true, 'El pedido se se envio correctamente!')
        : OrderResult(false, ''));
    }
  }

  _regresarAPendientes(BuildContext context){
    Navigator.pop(context, true);
  }
}
