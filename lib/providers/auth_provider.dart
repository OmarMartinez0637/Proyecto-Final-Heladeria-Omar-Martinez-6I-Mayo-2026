import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;
  bool _isAdmin = false;

  User? get user => _user;
  bool get isAdmin => _isAdmin;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Login Dinámico (Verificación simple de Admin por correo para este diseño)
  Future<bool> login(String email, String password, bool attemptAdmin) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      _user = result.user;
      
      // Lógica de roles simplificada (puedes cambiarla por Custom Claims o un documento en Firestore)
      if (attemptAdmin && email.contains('admin')) {
        _isAdmin = true;
      } else {
        _isAdmin = false;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Registro de usuarios
  Future<bool> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      if (result.user != null) {
        await _db.collection('users').doc(result.user!.uid).set({
          'uid': result.user!.uid,
          'email': email,
          'role': 'user', // Por defecto rol de usuario
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      _isAdmin = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Cerrar Sesión
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _isAdmin = false;
    notifyListeners();
  }
}