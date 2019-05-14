class DatosAsignacionResponse {
  final bool error;
  final String mensaje;

  DatosAsignacionResponse({this.error, this.mensaje});
    factory DatosAsignacionResponse.fromJson(Map<String, dynamic> json) {

      return DatosAsignacionResponse(
          error: json['error'], mensaje: json['mensaje']);
  }
}