import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';
import '../utils/constants.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    // Filtrar los productos según la categoría activa en el navbar
    final productsProv = context.watch<ProductsProvider>();
    final categoryProducts = productsProv.getByCategory(category);
    final cartProv = context.read<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nuestros $category",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Expanded(
              child: categoryProducts.isEmpty
                  ? Center(child: Text("No hay productos en esta categoría por ahora."))
                  : GridView.builder(
                      itemCount: categoryProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        final product = categoryProducts[index];
                        return GestureDetector(
                          onTap: () {
                            // Al dar click a la card, manda al detalle del producto
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Foto del producto
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                      image: DecorationImage(
                                        image: NetworkImage(product.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      // Precio en rojo
                                      Text(
                                        "\$${product.price.toStringAsFixed(2)}",
                                        style: TextStyle(color: AppColors.dqRed, fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      SizedBox(height: 8),
                                      // Botón rojo para agregar al carrito
                                      SizedBox(
                                        width: double.infinity,
                                        height: 35,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.dqRed,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          onPressed: () {
                                            cartProv.addToCart(product);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text("${product.name} agregado al carrito"),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                          child: Text("Agregar", style: TextStyle(color: Colors.white, fontSize: 13)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PÁGINA DE DETALLE DEL PRODUCTO ---
class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProv = context.read<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(product.name, style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 24, color: AppColors.dqRed, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Chip(
                    label: Text(product.category),
                    backgroundColor: AppColors.lilaBg,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.4),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dqRed,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      cartProv.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("¡${product.name} añadido al carrito!")),
                      );
                    },
                    child: Text("Agregar al Carrito", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}