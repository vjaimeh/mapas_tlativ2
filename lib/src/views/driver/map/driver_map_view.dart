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
  DriverMapController _con = DriverMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
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

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () {},
        icon: Icon(
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
        text: 'Conectarse',
        color: Colors.amber,
        textColor: Colors.black,
        onPressed: () {},
        //onPressed:,
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
