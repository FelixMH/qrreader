import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets';

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.my_location ),
            onPressed: () {
              map.move( scan.getLatLng(), 15.0*4 );
            },
          ),
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante( context ),
    );
  }

  Widget _crearFlutterMap( ScanModel scan ) {

    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 10,
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores( scan ),
      ],
    );

  }

  _crearMapa() {
    return TileLayerOptions(
      urlTemplate: 'https://api.tiles.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken': 'pk.eyJ1IjoiZGV2ZWxvcGVyYW50aSIsImEiOiJjazlwZHlsaWswYTh4M2ZwN2N4bnZ0NHlnIn0.GbOJixOqMoYIdlkCfpiGaw',
        'id': 'mapbox.$tipoMapa'
      }
    );
  }

  _crearMarcadores( ScanModel scan ) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: ( context ) => Container(
            child: Icon(
              Icons.location_on,
              size: 75.0,
              color: Theme.of(context).primaryColor,
            ),
          )
        ),
      ],
    );
  }

  Widget _crearBotonFlotante( BuildContext context ) {
    return FloatingActionButton(
      child: Icon( Icons.repeat ),
      onPressed: () {

        if ( tipoMapa == 'streets' ) {
          tipoMapa = 'dark';
        } else if ( tipoMapa == 'dark' ) {
          tipoMapa = 'light';
        } else if ( tipoMapa == 'light' ) {
          tipoMapa = 'outdoors';
        } else if ( tipoMapa == 'outdoors' ) {
          tipoMapa = 'satelite';
        } else {
          tipoMapa = 'streets';
        }

        setState(() {}); // redibuja la app.

      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}