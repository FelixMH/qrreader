import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreaderapp/src/utils/utils.dart' as utils;

import 'package:qrreaderapp/src/pages/mapas_page.dart';
import 'package:qrreaderapp/src/pages/direcciones_page.dart';


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
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.delete_forever ),
            onPressed: scansBloc.borrarScansTODOS,
          )
        ],
      ),
      body: _callPage( currentIndex ),
      bottomNavigationBar: _menuTab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon( Icons.filter_center_focus ),
        onPressed: () => _scanQR( context ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  ScanResult scanResult;
  Future _scanQR( BuildContext context ) async {

    String futurestring;

    try {
      var result = await BarcodeScanner.scan();
      setState(() => scanResult = result);
      futurestring = scanResult.rawContent.toString();
    } catch( e ) {
      futurestring = e.toString();
    }

    if ( futurestring != null ) {
      
      final scan = ScanModel( valor: futurestring );
      scansBloc.agregarScan(scan);

      if ( Platform.isIOS ) {
        Future.delayed( Duration( milliseconds: 750 ), () {
          utils.abrirScan(scan, context);
        });
      } else {
        utils.abrirScan(scan, context);
      }

      
    }

  }


  Widget _callPage( int currentPage ) {
    switch( currentPage ) {
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }
  }

  Widget _menuTab() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.map ),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.brightness_5 ),
          title: Text('Direcciones')
        ),
      ],
    );
  }
}