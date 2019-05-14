// FirstScreen.dart

import 'package:app_pedidos/OrderPage.dart';
import 'package:app_pedidos/api/providers/OrderProvider.dart';
import 'package:app_pedidos/api/request_objects/GetOrdersRequest.dart';
import 'package:app_pedidos/api/response_objects/GetOrdersResponse.dart';
import 'package:flutter/material.dart';

class Entregados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: FutureBuilder<GetOrdersResponse>(
            future: OrderProvider().getOrderDelivered(
              GetOrdersRequest('entregados')), //sets the getQuote method as the expected Future
            builder: (context, snapshot) {
              if (snapshot.hasData) { //checks if the response returns valid data
                return Center(
                  child: ListView.builder(
                    itemCount: snapshot.data.orders.length,
                    itemBuilder: (BuildContext context, int index){
                      //if (index.isOdd) return Divider();
                      return ListTile(
                        contentPadding: EdgeInsets.all(10.0),
                        title: new Text("Pedido No. "+snapshot.data.orders[index].getNoPedido()+" | "+snapshot.data.orders[index].getPara()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Column(children: <Widget>[
                            //   Text(snapshot.data.orders[index].getNoPedido()),
                            //   Text(snapshot.data.orders[index].getFechaEntrega())
                            // ],),
                            Text(snapshot.data.orders[index].getDireccionEntrega()),
                            Text(snapshot.data.orders[index].getReferencia())
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => OrderPage(order: snapshot.data.orders[index])));
                        },
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) { //checks if the response throws an error
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
    );
  }
}