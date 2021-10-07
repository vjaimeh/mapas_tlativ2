import 'package:flutter/material.dart';

class ClientMapView extends StatefulWidget {
  const ClientMapView({Key? key}) : super(key: key);

  @override
  _ClientMapViewState createState() => _ClientMapViewState();
}

class _ClientMapViewState extends State<ClientMapView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Mapa del cliente'),
      ),
    );
  }
}
