import 'dart:io';
import 'package:path/path.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if ( _database != null ) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'ScansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );
  }


  // CREAR Registros

  nuevoScanRaw( ScanModel nuevoScan ) async {
    final db = await database;

    final res = await db.rawInsert(
      "INSERT Into Scans( id, tipo, valor ) "
      "VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )"
    );

    return res;
  }

  nuevoScan( ScanModel nuevoScan ) async {

    final db = await database;

    final res = await db.insert( 'Scans', nuevoScan.toJson() );

    return res;
  }

  Future<ScanModel> getScanId( int id ) async {
    final db = await database;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [ id ] );

    return res.isNotEmpty ? ScanModel.fromJson( res.first ) : null;
  }

  Future<List<ScanModel>> getTodos() async {
    final db = await database;

    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty
                            ? res.map( ( c ) => ScanModel.fromJson( c ) ).toList()
                            : [];
    
    return list;
  }

  Future<List<ScanModel>> getTodosPorTipo( String tipo ) async {
    final db = await database;

    final res = await db.query('Scans', where: 'tipo = ?', whereArgs: [ tipo ] );

    List<ScanModel> list = res.isNotEmpty
                            ? res.map( ( c ) => ScanModel.fromJson( c ) ).toList()
                            : [];
    
    return list;
  }

  // Actualizar Registros => Update Querys

  Future<int> updateScans( ScanModel nuevoScan ) async {
    final db = await database;

    final res = await db.update( 'Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [ nuevoScan.id ] );

    return res;
  }

  // Eliminar Registros => Delete

  deleteScan( int id ) async {
    final db = await database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [ id ] );

    return res;
  }

  deleteAll() async {
    final db = await database;
    return await db.delete('Scans');
  }













}