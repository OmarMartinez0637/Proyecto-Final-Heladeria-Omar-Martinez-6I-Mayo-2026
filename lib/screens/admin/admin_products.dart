import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../models/product_model.dart';
import '../../utils/constants.dart';

class AdminProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProv = context.watch<ProductsProvider>();
    final products = productsProv.products;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Productos", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            IconButton(
              icon: Icon(Icons.add_circle, color: AppColors.dqRed, size: 30),
              onPressed: () => _showProductForm(context, null),
            )
          ],
        ),
      ),
      body: products.isEmpty
          ? Center(child: Text("No hay productos registrados."))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Categoría')),
                    DataColumn(label: Text('Precio')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: products.map((p) {
                    return DataRow(cells: [
                      DataCell(Text(p.name)),
                      DataCell(Text(p.category)),
                      DataCell(Text("\$${p.price.toStringAsFixed(2)}")),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showProductForm(context, p),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => productsProv.deleteProduct(p.id),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
    );
  }

  void _showProductForm(BuildContext context, ProductModel? product) {
    final isEdit = product != null;
    final nameCtrl = TextEditingController(text: isEdit ? product.name : '');
    final priceCtrl = TextEditingController(text: isEdit ? product.price.toString() : '');
    final descCtrl = TextEditingController(text: isEdit ? product.description : '');
    final imgCtrl = TextEditingController(text: isEdit ? product.imageUrl : '');
    String selectedCategory = isEdit ? product.category : 'Helados';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? "Editar Producto" : "Agregar Producto"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Nombre")),
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: ['Helados', 'Blizzards', 'Bebidas', 'Pasteles'].map((String val) {
                    return DropdownMenuItem<String>(value: val, child: Text(val));
                  }).toList(),
                  onChanged: (value) => setDialogState(() => selectedCategory = value!),
                ),
                TextField(controller: priceCtrl, decoration: InputDecoration(labelText: "Precio"), keyboardType: TextInputType.number),
                TextField(controller: descCtrl, decoration: InputDecoration(labelText: "Descripción")),
                TextField(controller: imgCtrl, decoration: InputDecoration(labelText: "URL Imagen")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
            TextButton(
              onPressed: () async {
                final newProduct = ProductModel(
                  id: isEdit ? product.id : '',
                  name: nameCtrl.text,
                  category: selectedCategory,
                  price: double.tryParse(priceCtrl.text) ?? 0.0,
                  description: descCtrl.text,
                  imageUrl: imgCtrl.text,
                );

                if (isEdit) {
                  await context.read<ProductsProvider>().updateProduct(product.id, newProduct);
                } else {
                  await context.read<ProductsProvider>().addProduct(newProduct);
                }
                Navigator.pop(context);
              },
              child: Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}