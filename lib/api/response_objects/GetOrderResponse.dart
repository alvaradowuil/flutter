class GetOrderResponse {
  final String cliente;
  final String telefono;
  final String nopedido;
  final String factura;
  final String fechaPedido;
  final String arreglos;
  final String para;
  final String telefonoRecibe;
  final String direccionEntrega;
  final String referencia;
  final String fechaEntrega;
  final String imagenes;

  final bool error;
  final String mensaje;
  final String imagenRecoger;




  GetOrderResponse({this.cliente, 
  this.telefono, 
  this.nopedido, 
  this.factura, 
  this.fechaPedido,
  this.arreglos,
  this.para,
  this.telefonoRecibe,
  this.direccionEntrega,
  this.referencia,
  this.fechaEntrega,
  this.imagenes,
  this.error,
  this.mensaje,
  this.imagenRecoger});
  
  factory GetOrderResponse.fromJson(Map<String, dynamic> json) {
    return GetOrderResponse(
      
        cliente: json['cliente'] != null ? json['cliente'] : '',
        telefono: json['telefono'] != null ? json['telefono'] : '',
        nopedido: json['nopedido'] != null ? json['nopedido'] : '',
        factura: json['factura'] != null ? json['factura'] : '',
        fechaPedido: json['fechapedido'] != null ? json['fechapedido'] : '',
        arreglos: json['arreglos'] != null ? json['arreglos'] : '',
        para: json['para'] != null ? json['para'] : '',
        telefonoRecibe: json['telefonorecibe'] != null ? json['telefonorecibe'] : '',
        direccionEntrega: json['direccionentrega'] != null ? json['direccionentrega'] : '',
        referencia: json['referencia'] != null ? json['referencia'] : '',
        fechaEntrega: json['fechaentrega'] != null ? json['fechaentrega'] : '',
        imagenes: json['imagenes'] != null ? json['imagenes'] : '',
        error: json['error'] != null ? json['error'] : false,
        mensaje: json['mensaje'] != null ? json['mensaje'] : '',
        imagenRecoger: json['imagenrecoger'] != null ? json['imagenrecoger'] : '',

        );
  }

  getNoPedido() => this.nopedido;
  getCliente() => this.cliente;
  getFechaPedido() => this.fechaPedido;
  getArreglos() => this.arreglos;
  getPara() => this.para;
  getTelefonoRecibe() => this.telefonoRecibe;
  getDireccionEntrega() => this.direccionEntrega;
  getReferencia() => this.referencia;
  getFechaEntrega() => this.fechaEntrega;
  getImagenes() => this.imagenes.split(",");

  getError() => this.error;
  getMensaje() => this.mensaje;

  getImagenRecoger() => this.imagenRecoger;

}