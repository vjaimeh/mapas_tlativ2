import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_tlati/src/controllers/driver_map_controller.dart';
import 'package:mapas_tlati/src/widgets/button_app.dart';

class DriverMapView extends StatefulWidget {
  const DriverMapView({Key? key}) : super(key: key);

  @override
  _DriverMapViewState createState() => _DriverMapViewState();
}

class _DriverMapViewState extends State<DriverMapView> {
  final DriverMapController _con = DriverMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('Se ejecuto el dispose');

    _con.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buttonDrawer(), _buttonCenterPosition()],
                ),
                Expanded(child: Container()),
                _buttonConnect(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Drawer
  // ignore: unused_element
  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: const Text(
                    'Nombre de Usario',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                Container(
                  child: const Text(
                    'Email',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/img/profile.jpg'),
                  radius: 40,
                )
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
          ),
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Cerrar Secion'),
            trailing: const Icon(Icons.power_settings_new),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  //drawer fin

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        onPressed: _con.openDrawer,
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        shape: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const Icon(
            Icons.location_searching,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buttonConnect() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: _con.connect,
        text: _con.isConnect ? 'DESCONECTARSE' : 'CONECTARSE',
        color: _con.isConnect ? Colors.grey : Colors.amber,
        textColor: Colors.black,
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
    );
  }

  void refresh() {
    setState(() {});
  }
}
