import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:mapas_tlati/src/controllers/client_register_controller.dart';
import 'package:mapas_tlati/src/utils/colors.dart' as utils;
import 'package:mapas_tlati/src/widgets/button_app.dart';

class ClientRegisterView extends StatefulWidget {
  const ClientRegisterView({Key? key}) : super(key: key);

  @override
  _ClientRegisterViewState createState() => _ClientRegisterViewState();
}

class _ClientRegisterViewState extends State<ClientRegisterView> {
  final ClientRegisterController _con = ClientRegisterController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textLogin(),
            _textFieldUsername(),
            _textFieldEmail(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttoRegister()
          ],
        ),
      ),
    );
  }

  Widget _buttoRegister() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.register,
        text: 'Registrarse',
        color: utils.Colors.primaryColor,
        icon: Icons.person_add,
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        decoration: const InputDecoration(
            hintText: 'correo@gmail.com',
            labelText: 'Correo electrónico:',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: utils.Colors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: const InputDecoration(
            labelText: 'Contraseña:',
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: utils.Colors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        obscureText: true,
        controller: _con.confirmpasswordController,
        decoration: const InputDecoration(
            labelText: 'Confirmar contraseña:',
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: utils.Colors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldUsername() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.usernameController,
        decoration: const InputDecoration(
            hintText: 'Usuario',
            labelText: 'Nombre de usuario:',
            prefixIcon: Icon(
              Icons.person_outlined,
              color: utils.Colors.primaryColor,
            )),
      ),
    );
  }

  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: const Text(
        'REGISTRO',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * .22,
        color: utils.Colors.primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/img/logo_app.jpg', width: 180, height: 130),
            const Text('Tlati Digital',
                style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        ),
      ),
    );
  }
}
