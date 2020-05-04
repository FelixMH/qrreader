import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    obtenerScans();
  }

  final scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream     => scansController.stream.transform( validarGeo );
  Stream<List<ScanModel>> get scansStreamHttp => scansController.stream.transform( validarHttp );


  dispose() {
    scansController?.close();
  }

  obtenerScans() async {
    scansController.sink.add( await DBProvider.db.getTodos() );
  }

  agregarScan( ScanModel scan ) async {
    await DBProvider.db.nuevoScan( scan );
    obtenerScans();
  }

  borrarScan( int id ) async {
    await DBProvider.db.deleteScan( id );
    obtenerScans();
  }

  borrarScansTODOS() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }






}