// login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isAdminLogin = ModalRoute.of(context)!.settings.arguments as bool;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, iconTheme: IconThemeData(color: AppColors.dqBlue)),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(isAdminLogin ? "Login Admin" : "Bienvenido", style: TextStyle(fontSize: 30, color: AppColors.dqBlue, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Correo Electrónico")),
            TextField(controller: _passController, decoration: InputDecoration(labelText: "Contraseña"), obscureText: true),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.dqBlue, minimumSize: Size(double.infinity, 50)),
              onPressed: () async {
                bool success = await context.read<AuthProvider>().login(_emailController.text, _passController.text, isAdminLogin);
                if (success) {
                  Navigator.pushReplacementNamed(context, isAdminLogin ? '/admin' : '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al iniciar sesión")));
                }
              },
              child: Text("Entrar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}