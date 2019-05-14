import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './principales/Escanear.dart';
import './principales/Pendientes.dart';
import './principales/Entregados.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTabController(),
    );
  }
}

class MyTabController extends StatefulWidget {
  static MyTabControllerState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<MyTabControllerState>());
  final String title;
  MyTabController({Key key, this.title}) : super(key: key);

  @override
  MyTabControllerState createState() => new MyTabControllerState();
}

Future<String> getNameWelcome() async {
  final prefs = await SharedPreferences.getInstance();

  return 'Bienvenido ' + prefs.getString('username') ?? 'Usuario';
}

class MyTabControllerState extends State<MyTabController> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  
  final List<Tab> myTabs = <Tab> [
              Tab(
                icon: Icon(Icons.scanner),
                text: "Recoger y asignar",
              ),
              Tab(
                icon: Icon(Icons.access_alarm),
                text: "Pendientes",
              ),
              Tab(
                icon: Icon(Icons.done_all),
                text: "Entregados",
              )
            ];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //tabController = new TabController(vsync: this, length: myTabs.length);
    
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    
  }

  @override
void didChangeAppLifecycleState(AppLifecycleState state) {
  print('state = $state');
}

  Text tituloAppBar = Text("Pedidos");

  //TabController _tabController = new TabController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            //controller: tabController,
            indicatorColor: Colors.white,
            tabs: myTabs,
          ),
          title: tituloAppBar,
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: [Escanear(), Pendientes(), Entregados()],
        ),
        drawer: Builder(
          builder: (context) => Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      padding: EdgeInsets.zero,
                      child: new Stack(fit: StackFit.expand, children: <Widget>[
                        Image(
                          image: new AssetImage(
                              "assets/images/portada-capeiros.jpg"),
                          fit: BoxFit.cover,
                          color: Colors.black54,
                          colorBlendMode: BlendMode.darken,
                        ),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FutureBuilder(
                              future: getNameWelcome(),
                              builder: (BuildContext context, AsyncSnapshot snapshot){
                                if (snapshot.hasData){
                                  if (snapshot.data != null){
                                    return Text(snapshot.data,
                                    style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.5,
                                fontSize: 20,
                              ),);
                                  }
                                  
                                }
                              },)
                          ],
                        ),
                      ]),
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                      ),
                    ),
                    ListTile(
                      title: Text('Cerrar sesión'),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            title: new Text("Cerrar sesión"),
                            content: new Text("¿Está seguro que desea cerrar sesión?"),
                            actions: <Widget>[  
                              // usually buttons at the bottom of the dialog
                              new FlatButton(
                                child: new Text("Si"),
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.clear();
                                  exit(0);
                                },
                              ),
                              new FlatButton(
                                child: new Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            );
                          },
                        );
                      },
                    ),
                    // ListTile(
                    //   title: Text('Ver mis estadísticas'),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //   },
                    // )
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
