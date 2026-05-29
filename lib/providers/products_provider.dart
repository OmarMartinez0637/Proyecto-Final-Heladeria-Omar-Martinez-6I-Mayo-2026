import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  // Escuchar productos en tiempo real
  void listenProducts() {
    _db.collection('products').orderBy('createdAt', descending: true).snapshots().listen((snapshot) {
      _products = snapshot.docs.map((doc) => ProductModel.fromFirestore(doc.data(), doc.id)).toList();
      notifyListeners();
    });
  }

  // Obtener el último producto agregado para el banner de "Inicio"
  ProductModel? get latestProduct {
    return _products.isNotEmpty ? _products.first : null;
  }

  // Filtrar por categoría en la app
  List<ProductModel> getByCategory(String category) {
    return _products.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // ================= OPERACIONES CRUD (ADMIN) =================
  Future<void> addProduct(ProductModel product) async {
    await _db.collection('products').add(product.toFirestore());
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    await _db.collection('products').doc(id).update(product.toFirestore());
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
  }
}