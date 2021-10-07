// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mapas_tlati/src/views/client/map/client_map_view.dart';
import 'package:mapas_tlati/src/views/driver/map/driver_map_view.dart';
import 'package:mapas_tlati/src/views/driver/register/driver_register_view.dart';
import 'package:mapas_tlati/src/views/home/home_view.dart';
import 'package:mapas_tlati/src/views/login/login_view.dart';
import 'package:mapas_tlati/src/utils/colors.dart' as utils;
import 'package:mapas_tlati/src/views/client/register/client_register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uber Clone',
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme:
            const AppBarTheme(elevation: 0, color: utils.Colors.primaryColor),
      ),
      routes: {
        'home': (BuildContext context) => const HomeView(),
        'login': (BuildContext context) => const LoginView(),
        'client/register': (BuildContext context) => const ClientRegisterView(),
        'driver/register': (BuildContext context) => const DriverRegisterView(),
        'driver/map': (BuildContext context) => const DriverMapView(),
        'client/map': (BuildContext context) => const ClientMapView(),
      },
    );
  }
}
