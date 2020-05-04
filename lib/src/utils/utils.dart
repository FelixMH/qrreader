import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

abrirScan( ScanModel scan, BuildContext context ) async {
  if ( scan.tipo == 'http' ) {
    if ( await canLaunch( scan.valor ) ) {
      await launch( scan.valor );
    }
  } else {
    Navigator.pushNamed(context, 'maps', arguments: scan);
  }
}


//   abrirScan() async {
//     const url = 'https://flutter.dev';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
// }