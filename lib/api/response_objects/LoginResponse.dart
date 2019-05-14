class LoginResponse {
  final String id;
  final String name;

  LoginResponse({this.id, this.name});
    factory LoginResponse.fromJson(Map<String, dynamic> json) {

      return LoginResponse(
          id: json['id'],
          name: json['name']);
  }
}