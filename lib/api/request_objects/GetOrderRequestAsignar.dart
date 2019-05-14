
import 'dart:io';
class GetOrderRequestAsignar {
  final String code;
  final File foto;

  GetOrderRequestAsignar(this.code, this.foto);

  getCode() => this.code;
  getFoto() => this.foto;
}