
import 'package:flutter/material.dart';
import 'package:lectorqr/src/bloc/scans_bloc.dart';
import 'package:lectorqr/src/models/scan_model.dart';
import 'package:lectorqr/src/utils/scan_utils.dart' as utils;


class DireccionesPage extends StatelessWidget {
  final scansBloc = new ScansBloc();
  @override
  Widget build(BuildContext context) {
    scansBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStreamHttp,
      builder: (BuildContext context, AsyncSnapshot <List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center( child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(
            child: Text('No hay registros'),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index) => Dismissible(
            key: UniqueKey(),
            background: _slideIzquierdaEliminar(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction){
              scansBloc.borrarScan(scans[index].id);
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(" scan eliminado"), backgroundColor: Colors.red ));
            },
            child: ListTile(
              leading: Icon(Icons.cloud_queue, color: Theme.of(context).primaryColor),
              title: Text(scans[index].valor),
              subtitle: Text('ID: ${scans[index].id}'),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              onTap: () => utils.abrirScan(context ,scans[index]),
            ),
          ),
        );
      },
    );
  }
  Widget _slideIzquierdaEliminar(){
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(Icons.delete_outline, color: Colors.white,),
          Text(
            " Eliminar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  
}