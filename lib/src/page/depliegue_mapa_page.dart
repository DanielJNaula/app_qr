
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lectorqr/src/models/scan_model.dart';


class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location), 
            onPressed: (){
              map.move(scan.obtenerCoordenadas(), 15);
            }
          )
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBottonFlotante(context, scan),
    );
  }

  Widget _crearBottonFlotante( BuildContext context, ScanModel scan ){
    return FloatingActionButton(
      child: Icon( Icons.repeat ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){ 
        print('entre');  
    /*
      streets-v11
      dark-v10
      outdoors-v11
    */
        if(tipoMapa == 'streets-v11') {
          tipoMapa = 'dark-v10';
        } else if(tipoMapa == 'dark-v10') {
          tipoMapa = 'light-v10';
        } else if(tipoMapa == 'light-v10') {
          tipoMapa = 'outdoors-v11';
        } else if(tipoMapa == 'outdoors-v11') {
          tipoMapa = 'satellite-v9';
        } else {
          tipoMapa = 'streets-v11';
        }
 
        setState((){ });
        //movimiento #1 al maximo de zoom
        map.move(scan.obtenerCoordenadas(), 30);
    
        //Regreso al Zoom Deseado después de unos Milisegundos
        Future.delayed(Duration(milliseconds: 50),(){
          map.move(scan.obtenerCoordenadas(), 15);
        });
        
      }
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.obtenerCoordenadas(),
        zoom: 13
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/'
      '{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}', 
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiZGFuaWVsMTk5NG5hdWxhIiwiYSI6ImNrZmZ4Mzc4NjBqMXkyd25tZTdxanVzN3EifQ.PcUj-dMwyDT5OkmMN23fNQ',
        'id': 'mapbox/$tipoMapa' 
         }
    );
  }

  _crearMarcadores(ScanModel scan){

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.obtenerCoordenadas(),
          builder: (context) => Container(
            child: Icon(Icons.location_on, size: 70.0,color: Theme.of(context).primaryColor),
          )
        )
      ]
    );
  }
}