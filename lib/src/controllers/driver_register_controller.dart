import 'package:flutter/material.dart';
import 'package:mapas_tlati/src/models/driver.dart';
import 'package:mapas_tlati/src/providers/auth_provider.dart';
import 'package:mapas_tlati/src/providers/client_provider.dart';
import 'package:mapas_tlati/src/providers/driver_provider.dart';
import 'package:mapas_tlati/src/utils/my_progress_dialog.dart';
import 'package:mapas_tlati/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class DriverRegisterController {
  BuildContext? context;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();
  TextEditingController pin6Controller = TextEditingController();

  late AuthProvider _authProvider;
  late DriverPovider _driverPovider;
  late ProgressDialog _progressDialog;

  Future? init(BuildContext context) {
    this.context = context;
    _authProvider = AuthProvider();
    _driverPovider = DriverPovider();
    _progressDialog =
        MyProgresDialog.createProgressDialog(context, 'Espere un momento...');
  }

  void register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = "$pin1$pin2$pin3 - $pin4$pin5$pin6";

    print('correo: $email');
    print('contraseña: $password');
    print('username : $username');
    print('confirmcontraseña: $confirmpassword');

    if (username.isEmpty &&
        email.isEmpty &&
        password.isEmpty &&
        confirmpassword.isEmpty) {
      print('Debes ingresar todos los datos');
      utils.Snackbar.showSnackbar(
          context!, key, 'Debes ingresar todos los datos');

      return;
    }
    if (confirmpassword != password) {
      print('Incorrecto');
      utils.Snackbar.showSnackbar(
          context!, key, 'Las contraseñas no coinciden');

      return;
    }

    if (password.length <= 6) {
      print('Debe ser mayor a 6');
      utils.Snackbar.showSnackbar(
          context!, key, 'La contraseña debe ser mayor a 6 caracteres');

      return;
    }
    _progressDialog.show();
    try {
      bool isRegister = await _authProvider.register(email, password);
      if (isRegister) {
        Driver driver = Driver(
            id: _authProvider.getUser()!.uid,
            email: _authProvider.getUser()!.uid,
            username: username,
            password: password,
            plate: plate
        );

        await _driverPovider.create(driver);
        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context!, 'driver/map', (route)=>false);
        print('El conductor se registró');
      } else {
        _progressDialog.hide();
        print('El usuario NO se registró');
      }
    } catch (error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context!, key, 'Error: $error');
      print('Error: $error');
    }
  }
}
