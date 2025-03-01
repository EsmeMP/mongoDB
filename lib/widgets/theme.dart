import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData tema1() {
  return ThemeData(
      //color de fondo
      scaffoldBackgroundColor: Colors.cyan[50],

      //color de la barra de navegación
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 0, 46, 52),
        titleTextStyle: GoogleFonts.aBeeZee(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      // estilos de texto
      textTheme: TextTheme(
        //Titulos
        headlineMedium: GoogleFonts.langar(
          color: const Color.fromARGB(255, 0, 46, 52),
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ));
}
