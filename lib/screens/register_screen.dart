import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.dqBlue),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Crear Cuenta",
                style: TextStyle(
                  fontSize: 32, 
                  color: AppColors.dqBlue, 
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Correo Electrónico",
                  labelStyle: TextStyle(color: AppColors.dqBlue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.dqBlue)
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passController,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  labelStyle: TextStyle(color: AppColors.dqBlue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.dqBlue)
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPassController,
                decoration: InputDecoration(
                  labelText: "Confirmar Contraseña",
                  labelStyle: TextStyle(color: AppColors.dqBlue),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.dqBlue)
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 40),
              _isLoading
                  ? CircularProgressIndicator(color: AppColors.dqBlue)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dqBlue,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      onPressed: () async {
                        final email = _emailController.text.trim();
                        final password = _passController.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Por favor, llena todos los campos")),
                          );
                          return;
                        }

                        if (password != _confirmPassController.text.trim()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Las contraseñas no coinciden")),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);
                        bool success = await context.read<AuthProvider>().register(email, password);
                        setState(() => _isLoading = false);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("¡Registro exitoso!")),
                          );
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error al registrar. Intenta con otro correo.")),
                          );
                        }
                      },
                      child: Text(
                        "Registrarse", 
                        style: TextStyle(color: Colors.white, fontSize: 16)
                      ),
                    ),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "¿Ya tienes cuenta? Inicia sesión aquí",
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