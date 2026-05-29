import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProv = context.watch<CartProvider>();
    final cartItems = cartProv.items.values.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("🛒", style: TextStyle(fontSize: 64)),
                  SizedBox(height: 15),
                  Text("Tu carrito está vacío", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              // Miniatura de imagen
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 15),
                              // Info del producto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "\$${item.product.price.toStringAsFixed(2)} c/u",
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    Text(
                                      "Subtotal: \$${item.totalPrice.toStringAsFixed(2)}",
                                      style: TextStyle(color: AppColors.dqRed, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // Controles para EDITAR cantidad
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline, color: AppColors.dqRed),
                                    onPressed: () {
                                      cartProv.updateQuantity(item.product.id, item.quantity - 1);
                                    },
                                  ),
                                  Text(
                                    "${item.quantity}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: () {
                                      cartProv.updateQuantity(item.product.id, item.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Panel de checkout / Pasarela de pago simulada
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3)),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total a pagar:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              "\$${cartProv.totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 22, color: AppColors.dqRed, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dqBlue, // Azul corporativo para transacciones
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            // Simulación de Pasarela de Pago
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Pasarela de Pago"),
                                content: Text("Procesando tu pedido con Firebase... \n\n¡Pago Exitoso! Tu Blizzard estará listo pronto."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      cartProv.clearCart(); // Vaciar carrito tras la compra
                                      Navigator.pop(context);
                                    },
                                    child: Text("Aceptar"),
                                  )
                                ],
                              ),
                            );
                          },
                          child: Text("Proceder al Pago", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}