import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:mapas_tlati/src/providers/auth_provider.dart';
import 'package:mapas_tlati/src/providers/geofire_provider.dart';
import 'package:mapas_tlati/src/utils/my_progress_dialog.dart';
import 'package:mapas_tlati/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class DriverMapController {
  late BuildContext context;
  late Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition =
      const CameraPosition(target: LatLng(19.3269055, -99.0667375), zoom: 14.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  late Position _position;
  late StreamSubscription<Position> _positionStream;

  late BitmapDescriptor markerDriver;
  late GeoFireProvider _geoFireProvider;
  late AuthProvider _authProvider;
  bool isConnect = false;
  late ProgressDialog _progressDialog;

  late StreamSubscription<DocumentSnapshot> _statusSuscription;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geoFireProvider = GeoFireProvider();
    _authProvider = AuthProvider();
    _progressDialog =
        MyProgresDialog.createProgressDialog(context, 'Conectando ...');
    markerDriver =
        await createMarkerImagenFromAsset('assets/img/taxi_icon.png');

    checkGPS();
  }

  void openDrawer() {
    key.currentState!.openDrawer();
  }

  void dispose() {
    _positionStream.cancel();
    _statusSuscription.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geoFireProvider.create(
        _authProvider.getUser()!.uid, _position.latitude, _position.longitude);
    _progressDialog.hide();
  }

  void connect() {
    if (isConnect) {
      // isConnect = false;
      disconnect();
    } else {
      //isConnect = true;
      _progressDialog.show();
      updateLocation();
    }
  }

  void disconnect() {
    _positionStream.cancel();
    _geoFireProvider.delete(_authProvider.getUser()!.uid);
  }

  void checkIfIsConnect() {
    Stream<DocumentSnapshot> status =
        _geoFireProvider.getLocationByIdSteam(_authProvider.getUser()!.uid);

    _statusSuscription = status.listen((DocumentSnapshot document) {
      if (document.exists) {
        isConnect = true;
      } else {
        isConnect = false;
      }
      refresh();
    });
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = (await Geolocator.getLastKnownPosition())!;
      centerPosition();
      saveLocation();

      addMarker('driver', _position.latitude, _position.longitude,
          'Tu posicion', '', markerDriver);
      refresh();

      _positionStream = Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        _position = position;
        addMarker('driver', _position.latitude, _position.longitude,
            'Tu posicion', '', markerDriver);
        animateCamaraToPosition(_position.latitude, _position.longitude);
        saveLocation();
        refresh();
      });
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void centerPosition() {
    if (_position != null) {
      animateCamaraToPosition(_position.latitude, _position.longitude);
    } else {
      utils.Snackbar.showSnackbar(
          context, key, 'Aactiva el GPS paara obtener la posicion');
    }
  }

  void checkGPS() async {
    bool isLocationEnable = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnable) {
      print('Gps activado');
      updateLocation();
      checkIfIsConnect();
    } else {
      print('Gps Desactivado');

      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        checkIfIsConnect();

        print('activo el  Gps');
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future animateCamaraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0, target: LatLng(latitude, longitude), zoom: 17)));
    }
  }

  Future<BitmapDescriptor> createMarkerImagenFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
        await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading);

    markers[id] = marker;
  }
}
