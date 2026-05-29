import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  // Agregar o incrementar cantidad
  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existing) => CartItemModel(
        product: existing.product,
        quantity: existing.quantity + 1,
      ));
    } else {
      _items.putIfAbsent(product.id, () => CartItemModel(product: product));
    }
    notifyListeners();
  }

  // Editar cantidad directamente desde el carrito
  void updateQuantity(String productId, int quantity) {
    if (!_items.containsKey(productId)) return;
    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity = quantity;
    }
    notifyListeners();
  }

  // Eliminar un producto completo
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Vaciar carrito tras el pago
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}