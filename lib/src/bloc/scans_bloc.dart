
import 'dart:async';

import 'package:lectorqr/src/bloc/validaciones.dart';
import 'package:lectorqr/src/providers/db_provider.dart';

class ScansBloc with Validaciones{
  
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    //OBTENER LOS SCANS DE LA BASE DE DATOS
    obtenerScans();
  } 

  final _scansStreamController = StreamController<List<ScanModel>>.broadcast();
  Stream<List<ScanModel>> get scansStream => _scansStreamController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansStreamController.stream.transform(validarHttp);

  
  dispose(){
    _scansStreamController?.close();
  }

  obtenerScans() async{
    _scansStreamController.sink.add( await DBProvider.db.obtenerTodosScan());
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();

  }

  borrarScan( int id ) async{
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos() async{
    await DBProvider.db.deleteTodosScan();
    obtenerScans();
  }


}