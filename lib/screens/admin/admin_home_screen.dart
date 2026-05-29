import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../utils/constants.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;

    return Scaffold(
      appBar: AppBar(
        title: Text("Panel Administrativo"),
        backgroundColor: AppColors.dqBlue,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.dqRed,
        child: Icon(Icons.add),
        onPressed: () {
          // Mostrar diálogo para AGREGAR producto
        },
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return ListTile(
            leading: Image.network(p.imageUrl, width: 50),
            title: Text(p.name),
            subtitle: Text("\$${p.price}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () {}),
                IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () {
                   context.read<ProductsProvider>().deleteProduct(p.id);
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}