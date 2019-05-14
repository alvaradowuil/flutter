import 'package:flutter/material.dart';
import 'package:app_pedidos/api/providers/UserProvider.dart';
import 'package:app_pedidos/api/request_objects/LoginRequest.dart';
import 'package:app_pedidos/api/response_objects/LoginResponse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quotes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quote of the Day'),
        ),
        body: Center(
          child: FutureBuilder<LoginResponse>(
            //future: UserProvider().login(LoginRequest('app@fioriguate.com', 'moulinaem')), //sets the getQuote method as the expected Future
            builder: (context, snapshot) {
              if (snapshot.hasData) { //checks if the response returns valid data
                return Center(
                  child: Column(
                    children: <Widget>[
                      Text(snapshot.data.name), //displays the quote
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(" - ${snapshot.data.id}"), //displays the quote's author
                    ],
                  ),
                );
              } else if (snapshot.hasError) { //checks if the response throws an error
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
