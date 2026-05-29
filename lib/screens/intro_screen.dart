import 'package:flutter/material.dart';
import '../utils/constants.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🍦", style: TextStyle(fontSize: 100)),
              SizedBox(height: 20),
              Text(
                "Dairy Queen",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.dqBlue),
              ),
              Text(
                "El sabor de la alegría",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 50),
              // Botón Administrador
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dqBlue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login', arguments: true),
                child: Text("Iniciar como Administrador", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 15),
              // Botón Usuario
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dqBlue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pushNamed(context, '/login', arguments: false),
                child: Text("Iniciar como Usuario", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: Text(
                  "¿No tienes cuenta? Regístrate aquí",
                  style: TextStyle(color: AppColors.dqBlue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}