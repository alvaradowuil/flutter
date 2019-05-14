import 'dart:io';

import 'dart:typed_data';

class SaveOrderDeliveredRequest{
  final String client;
  final String date;
  final String orderId;
  final File picture;
  final String observaciones;
  final ByteData firma;

  SaveOrderDeliveredRequest(
    this.client, 
    this.date, 
    this.orderId, 
    this.picture, 
    this.observaciones,
    this.firma);

}