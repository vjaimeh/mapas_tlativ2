import 'package:flutter/material.dart';
import 'package:mapas_tlati/src/providers/auth_provider.dart';
import 'package:mapas_tlati/src/utils/shared_pref.dart';

class HomeController {

  BuildContext? context;
  late SharedPref _sharedPref;
  late AuthProvider _authProvider;
  late String _typeUser;

  Future? init(BuildContext context) async {
    this.context = context;
    _sharedPref = SharedPref();
    _authProvider = AuthProvider();
    _typeUser = await _sharedPref.read('typeUser');
    checkIfUserIsAuth();
  }

  void checkIfUserIsAuth() {
    bool isSigned = _authProvider.isSignedIn();
    if (isSigned) {

        if (_typeUser == 'client') {
          Navigator.pushNamedAndRemoveUntil(context!, 'client/map', (route) => false);
          // Navigator.pushNamed(context, 'client/map');
        }
        else {
          Navigator.pushNamedAndRemoveUntil(context!, 'driver/map', (route) => false);
          // Navigator.pushNamed(context, 'driver/map');
        }

    }
    else {
      print('NO ESTA LOGEADO');
    }
  }

  void goToLoginView(String typeUser){
    saveTypeUserClient(typeUser);
    Navigator.pushNamed(context!, 'login');
  }

  void saveTypeUserClient(String typeUser) async {
    _sharedPref.save('typeUser', typeUser);
  }

}