import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // Pasteles, Helados, Blizzards, Bebidas
  final DateTime? createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.createdAt,
  });

  // Convertir de Firestore Document a Objeto de Dart
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ProductModel(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Helados',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convertir de Objeto de Dart a JSON para Firebase (CRUD Admin)
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}