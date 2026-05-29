import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Colors.white;
  static const Color dqBlue = Colors.blue; // Para Login, Register e Intro
  static const Color dqRed = Colors.red;   // Para precios y botones
  static const Color lilaBg = Color(0xFFE8D7F5); // Fondo lila para las categorías de Inicio

  // Degradados de la pantalla de Inicio
  static const Gradient bannerPrincipal = LinearGradient(
    colors: [Colors.red, Colors.pinkAccent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Gradient bannerNuevo = LinearGradient(
    colors: [Colors.orange, Colors.red],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}