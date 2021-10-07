import 'package:flutter/material.dart';
import 'package:mapas_tlati/src/models/client.dart';
import 'package:mapas_tlati/src/models/driver.dart';
import 'package:mapas_tlati/src/providers/auth_provider.dart';
import 'package:mapas_tlati/src/utils/my_progress_dialog.dart';
import 'package:mapas_tlati/src/utils/shared_pref.dart';
import 'package:mapas_tlati/src/providers/client_provider.dart';
import 'package:mapas_tlati/src/providers/driver_provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';
import 'package:mapas_tlati/src/utils/snackbar.dart' as utils;

class LoginController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthProvider _authProvider;
  late ProgressDialog _progressDialog;
  late SharedPref _sharedPref;
  late String _typeUser;
  late ClientPovider _clientPovider;
  late DriverPovider _driverPovider;

  Future? init(BuildContext context) async{
    this.context = context;
    _authProvider = AuthProvider();
    _clientPovider = ClientPovider();
    _driverPovider = DriverPovider();
    _progressDialog = MyProgresDialog.createProgressDialog(context, 'Espera un momento...');
    _sharedPref = SharedPref();
    _typeUser = await _sharedPref.read('typeUser');
    print('********** TIPO DE USUARIO **********');
    print(_typeUser);
  }

  void goToRegisterView() {
    if (_typeUser == 'client') {
      Navigator.pushNamed(context!, 'client/register');
    }
    else {
      Navigator.pushNamed(context!, 'driver/register');
    }
  }

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    print('correo: $email');
    print('contraseña: $password');



      try {
        if (email.isEmpty || password.isEmpty) {
          print('Debes ingresar todos los datos');
          utils.Snackbar.showSnackbar(
              context!, key, 'Debes ingresar todos los datos');
        } else {
          bool isLogin = await _authProvider.login(email, password);
          _progressDialog.show();
          if (isLogin) {
            _progressDialog.hide();
            print('El usuario ha iniciado sesión');
            if (_typeUser == 'client') {
              Client? client = await _clientPovider.getById(
                  _authProvider.getUser()!.uid);
              print("CLIENTE: $client");
              if (client != null) {
                Navigator.pushNamedAndRemoveUntil(
                    context!, 'client/map', (route) => false);
              } else {
                utils.Snackbar.showSnackbar(
                    context!, key, '¡El usuario NO es válido!');
                await _authProvider.signOut();
              }
            }
            else if (_typeUser == 'driver') {
              Driver? driver = await _driverPovider.getById(
                  _authProvider.getUser()!.uid);
              print("DRIVER: $driver");
              if (driver != null) {
                Navigator.pushNamedAndRemoveUntil(
                    context!, 'driver/map', (route) => false);
              } else {
                utils.Snackbar.showSnackbar(
                    context!, key, '¡El usuario NO es válido!');
                await _authProvider.signOut();
              }
            }
          } else {
            print('No se pudo iniciar la sesión');
            utils.Snackbar.showSnackbar(
                context!, key, 'No se pudo iniciar la sesión');
          }
        }
      }catch (error) {
        utils.Snackbar.showSnackbar(context!, key, 'Correo y/o contraseña incorrecta');
        _progressDialog.hide();
        print('Error: $error');
      }
  }
}
