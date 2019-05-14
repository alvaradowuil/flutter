import 'package:app_pedidos/api/ApiMethods.dart';
import 'package:app_pedidos/api/request_objects/GetOrderRequestAsignar.dart';
import 'package:app_pedidos/api/request_objects/GetOrderRequest.dart';
import 'package:app_pedidos/api/request_objects/GetOrdersRequest.dart';
import 'package:app_pedidos/api/request_objects/SaveOrderDeliveredRequest.dart';
import 'package:app_pedidos/api/response_objects/GetOrderResponse.dart';
import 'package:app_pedidos/api/response_objects/GetOrdersResponse.dart';
import 'package:app_pedidos/api/response_objects/DatosEntregaResponse.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http_parser/http_parser.dart';

final headers = {"Accept": "application/json"};

class OrderProvider {
  
  Future<String> getOrderByCodeAsignar(
      GetOrderRequestAsignar getOrderRequest, accion(bool respuesta, GetOrderResponse datos)) async {
    // open a bytestream
    var stream = new http.ByteStream(
        DelegatingStream.typed(getOrderRequest.foto.openRead()));
    // get file length
    var length = await getOrderRequest.foto.length();

    // string to uri
    var uriPath = Uri.parse(ApiMethods().getOrderByCode());

    // create multipart request
    var request = new http.MultipartRequest("POST", uriPath);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('foto', stream, length,
        filename: basename(getOrderRequest.foto.path));

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    // add file to multipart
    request.files.add(multipartFile);
    request.fields['id'] = getOrderRequest.getCode();
    request.fields['repartidorId'] = userId;
  

    // send
    var response = await request.send();
    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      //devolvemos la respuesta
      print(value.toString());
      GetOrderResponse res =  GetOrderResponse.fromJson(json.decode(value.toString()));
      if(!res.error){
        accion(true, res);
      } else {
        accion(false, res);
      }
    });
      }

  Future<GetOrderResponse> getOrderByCode(GetOrderRequest getOrderRequest,
      accion(bool respuesta, GetOrderResponse datos)) async {
    final response = await http.post(ApiMethods().getOrderByCode(), body: {
      "id": getOrderRequest.getCode(),
    });

    if (response.statusCode == 200) {
      //return LoginResponse.fromJson(json.decode(response.body));
      print(response.body.toString());
      accion(true, GetOrderResponse.fromJson(json.decode(response.body)));
    } else {
      accion(false, null);
      //throw Exception('Failed to load post');
      //return LoginResponse.fromJson(json.decode(""));
    }
  }

  Future<GetOrdersResponse> getOrderByType(
      GetOrdersRequest getOrdersRequest) async {

        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');

    final response = await http.get(ApiMethods().getOrdersByType(
        userId, getOrdersRequest.getType()));

    if (response.statusCode == 200) {
      return GetOrdersResponse.fromJson(json.decode(response.body));
      //accion(true, GetOrdersResponse.fromJson(json.decode(response.body)));
    } else {
      //accion(false, null);
      //throw Exception('Failed to load post');
      return GetOrdersResponse.fromJson(json.decode(""));
    }
  }

  Future<GetOrdersResponse> getOrderPending(
      GetOrdersRequest getOrdersRequest) async {

        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');


    final response = await http.post(ApiMethods().getOrdersByType(
        userId, getOrdersRequest.getType()));

    if (response.statusCode == 200) {
      return GetOrdersResponse.fromJson(json.decode(response.body));
      //accion(true, GetOrdersResponse.fromJson(json.decode(response.body)));
    } else {
      //accion(false, null);
      //throw Exception('Failed to load post');
      return GetOrdersResponse.fromJson(json.decode(""));
    }
  }

  Future<GetOrdersResponse> getOrderDelivered(
      GetOrdersRequest getOrdersRequest) async {

        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');

    final response = await http.get(ApiMethods().getOrdersByType(
        userId, getOrdersRequest.getType()));

        print('---------------' + response.request.url.toString());

    if (response.statusCode == 200) {
      return GetOrdersResponse.fromJson(json.decode(response.body));
      //accion(true, GetOrdersResponse.fromJson(json.decode(response.body)));
    } else {
      //accion(false, null);
      //throw Exception('Failed to load post');
      return GetOrdersResponse.fromJson(json.decode(""));
    }
  }

  Future<String> saveOrderDelivered(
      SaveOrderDeliveredRequest saveOrderDeliveredRequest, accion(bool respuesta, String datos)) async {
    // open a bytestream
    var stream = new http.ByteStream(
        DelegatingStream.typed(saveOrderDeliveredRequest.picture.openRead()));
    // get file length
    var length = await saveOrderDeliveredRequest.picture.length();

    // string to uri
    var uriPath = Uri.parse(ApiMethods().saveOrderDelivered());

    // create multipart request
    var request = new http.MultipartRequest("POST", uriPath);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('foto', stream, length,
        filename: basename(saveOrderDeliveredRequest.picture.path));
    var multipartFirma = new http.MultipartFile.fromBytes(
      'firma', 
      saveOrderDeliveredRequest.firma.buffer.asUint8List(), filename: 'firma.png', contentType: MediaType("image", 'PNG'));

    // add file to multipart
    request.files.add(multipartFile);
    request.files.add(multipartFirma);
    request.fields['nombrePersonaRecibe'] = saveOrderDeliveredRequest.client;
    request.fields['fechaEntregado'] = saveOrderDeliveredRequest.date;
    request.fields['pedidoId'] = saveOrderDeliveredRequest.orderId;
    request.fields['observaciones'] = saveOrderDeliveredRequest.observaciones;

    // send
    var response = await request.send();
    print(response.statusCode);

    response.stream.transform(utf8.decoder).listen((value) {
      //devolvemos la respuesta

      print(value.toString());

      DatosEntregaResponse res =  DatosEntregaResponse.fromJson(json.decode(value.toString()));
      if(!res.error){
        accion(true, "Se cargó correctamente la imagen");
      } else {
        accion(true, "Ocurrió un error, intente de nuevo");
      }
    });

    // listen for response
    

    // request.files.add(
    //   new http.MultipartFile.fromBytes(
    //     'foto', await saveOrderDeliveredRequest.picture.readAsBytes(), contentType: new MediaType('image', 'jpeg')));
    if(response.statusCode == 200){
      return "Se están enviando los datos";
    } else {
      return "Ocurrio un error";
    }
    
  }
}
