import 'package:flutter/material.dart';
import 'package:mapas_tlati/src/utils/colors.dart' as utils;

class ButtonApp extends StatelessWidget {
  Color color;
  Color textColor;
  String text;
  IconData icon;
  Function onPressed;

  ButtonApp({Key? key,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    required this.onPressed,
    required this.text
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(height: 50, alignment: Alignment.center,
                child: Text(text,
                  style: const TextStyle(
                      fontSize: 16,
                  fontWeight: FontWeight.bold
                  ),
                ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                child: Icon(icon, color: utils.Colors.primaryColor),
                backgroundColor: Colors.white,
              ),
            ),
          )
        ],
      ),
        style: ElevatedButton.styleFrom(
          primary: color,
          onPrimary: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
        ),
    );
  }
}

/*
Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ElevatedButton.icon(
        label: const Text('Iniciar sesión'),
        icon: const Icon(Icons.done),
        style: ElevatedButton.styleFrom(
          primary: utils.Colors.primaryColor,
        ),
        onPressed: (){},
      ),
    )
*/