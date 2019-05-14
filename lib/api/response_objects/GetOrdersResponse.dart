import 'package:app_pedidos/api/response_objects/GetOrderResponse.dart';

class GetOrdersResponse{
  final List<GetOrderResponse> orders;

  GetOrdersResponse(this.orders);

  factory GetOrdersResponse.fromJson(List<dynamic> jsons) {

    List<GetOrderResponse> orders = new List();

    jsons.forEach((order) => {
      orders.add(GetOrderResponse(
        cliente: order['cliente'],
        telefono: order['telefono'],
        nopedido: order['nopedido'],
        factura: order['factura'],
        fechaPedido: order['fechapedido'],
        arreglos: order['arreglos'],
        para: order['para'],
        telefonoRecibe: order['telefonorecibe'],
        direccionEntrega: order['direccionentrega'],
        referencia: order['referencia'],
        fechaEntrega: order['fechaentrega'],
        imagenes: order['imagenes'],
        imagenRecoger: order['imagenrecoger']
      ))
    });

    return GetOrdersResponse(orders);
  }

  getOrders() => this.orders;
}