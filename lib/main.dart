import 'package:flutter/material.dart';
import 'package:lectorqr/src/page/depliegue_mapa_page.dart';

import 'package:lectorqr/src/page/home_page.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Leector QR',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        //'mapas': (BuildContext context) => MapasPage(),
        //'direciones': (BuildContext context) => DireccionesPage(),
        'mapa': (BuildContext context) => MapaPage()
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple
      ),
    );
  }
}