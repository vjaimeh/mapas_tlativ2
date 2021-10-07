import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:mapas_tlati/src/controllers/home_controller.dart';

class HomeView extends StatefulWidget {
   const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
   final HomeController _con = HomeController();

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
      body:  SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color.fromRGBO(36, 25, 55, .3), Color.fromRGBO(36, 25, 55, 1)]
            ),
          ),
          child: Column(
            children: [
              _bannerApp(context),
              const SizedBox(height: 50),
              _textSelectYourRol(),
              const SizedBox(height: 30),
              _imageTypeUser(context,'assets/img/pasajero.png', 'client'),
              const SizedBox(height: 10),
              _textTypeUser('Cliente'),
              const SizedBox(height: 30),
              _imageTypeUser(context,'assets/img/driver.png', 'driver'),
              const SizedBox(height: 10),
              _textTypeUser('Conductor'),
              SizedBox(height: MediaQuery.of(context).size.height * .14),
            ],
          ),
        ),
      ),
    );
  }

   Widget _bannerApp(BuildContext context) {
     return ClipPath(
       clipper: WaveClipperOne(),
       child: Container(
         height: MediaQuery.of(context).size.height*.3,
         color: Colors.white,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             Image.asset('assets/img/logo_app2.png',width: 200, height: 150),
             const Text('Tlati Digital', style: TextStyle(fontFamily: 'Pacifico', fontSize: 22, fontWeight: FontWeight.bold))
           ],
         ),
       ),
     );
   }

   Widget _textSelectYourRol() {
     return const Text(
       'SELECCIONA TU ROL', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'OneDay'));
   }

  Widget _imageTypeUser(BuildContext context, String typeImage, String typeUser){
    return GestureDetector(
        onTap: () => _con.goToLoginView(typeUser),
        child: CircleAvatar(
            backgroundImage: AssetImage(typeImage),
            radius: 50,
            backgroundColor: const Color.fromRGBO(36, 25, 55, 1)
        ),
    );
  }

  Widget _textTypeUser(String typeUser){
    return Text(typeUser, style: const TextStyle(color: Colors.white, fontSize: 16));
  }
}
