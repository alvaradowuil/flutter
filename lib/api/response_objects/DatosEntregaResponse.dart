class DatosEntregaResponse {
  final bool error;

  DatosEntregaResponse({this.error});
    factory DatosEntregaResponse.fromJson(Map<String, dynamic> json) {

      return DatosEntregaResponse(
          error: json['error']);
  }
}