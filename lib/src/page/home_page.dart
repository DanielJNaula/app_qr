import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:barcode_scan/barcode_scan.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:lectorqr/src/bloc/scans_bloc.dart';
import 'package:lectorqr/src/models/scan_model.dart';


import 'package:lectorqr/src/page/direcciones_page.dart';
import 'package:lectorqr/src/page/mapas_page.dart';
import 'package:lectorqr/src/utils/scan_utils.dart' as utils;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int currentIndex = 0;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.delete_forever), 
            onPressed: scansBloc.borrarScanTodos
          )
        ],
      ),
      body: _cargarPagina(currentIndex),
      bottomNavigationBar: _crearBotonesNavegacion(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _crearBotonFloating(),
    );
  }

  Widget _cargarPagina(int paginaActual){
    switch (paginaActual) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }
  }

  Widget _crearBotonFloating(){
    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus),
      onPressed: ()=>_escanearQR(context),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  _escanearQR(BuildContext context) async{
    //https://fernando-herrera.com
    ScanResult informacionQR;

    try {
      informacionQR = await BarcodeScanner.scan();
    } catch(e) {
      informacionQR.rawContent = e.toString();
    }

    
    if( informacionQR != null  && informacionQR.rawContent.length > 4){
      print(informacionQR);
      final scan = ScanModel( valor: informacionQR.rawContent);
      scansBloc.agregarScan(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750),(){
          utils.abrirScan(context,scan);
        });
      }else{
        utils.abrirScan(context,scan);
      }
      
      
    }
  }

  Widget _crearBotonesNavegacion() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      //debe ser mas de 1
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_7),
          title: Text('Direcciones')
        )
      ],
    );
  }
}