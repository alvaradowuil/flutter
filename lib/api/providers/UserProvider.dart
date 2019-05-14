import 'package:app_pedidos/api/ApiMethods.dart';
import 'package:app_pedidos/api/request_objects/LoginRequest.dart';
import 'package:app_pedidos/api/response_objects/LoginResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final headers = {"Accept": "application/json"};

class UserProvider {

  Future<LoginResponse> login(LoginRequest loginRequest, accion(bool respuesta, LoginResponse datos)) async {
    final response =
    await http.post(ApiMethods().login(), body: {
      "email": loginRequest.email, 
      "password": loginRequest.password
    });

    if (response.statusCode == 200) {
      //return LoginResponse.fromJson(json.decode(response.body));
      accion(true, LoginResponse.fromJson(json.decode(response.body)));
    } else {
      accion(false, null);
      //throw Exception('Failed to load post');
      //return LoginResponse.fromJson(json.decode(""));
    }
  }
}
