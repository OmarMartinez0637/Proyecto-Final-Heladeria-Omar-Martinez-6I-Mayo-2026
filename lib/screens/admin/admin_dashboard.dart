import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/products_provider.dart';
import '../../providers/branches_provider.dart';
import '../../utils/constants.dart';
import 'admin_categories.dart';
import 'admin_products.dart';
import 'admin_clients.dart';
import 'admin_branches.dart'; // <--- Nueva importación

class AdminDashboard extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final productCount = context.watch<ProductsProvider>().products.length;
    final branchCount = context.watch<BranchesProvider>().branches.length; // Conteo de sucursales

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Dashboard Admin", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GridView 2x2 de Funcionalidades
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _menuCard(context, "Categorías", "📂", Colors.blue, AdminCategoriesScreen()),
                _menuCard(context, "Productos", "🍦", Colors.purple, AdminProductsScreen()),
                _menuCard(context, "Clientes", "👥", Colors.green, AdminClientsScreen()),
                _menuCard(context, "Sucursales", "🏢", Colors.orange, AdminBranchesScreen()), // <--- Reemplazado aquí
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Estadísticas rápidas",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            
            // Sección de estadísticas ajustada
            StreamBuilder<QuerySnapshot>(
              stream: _db.collection('users').snapshots(),
              builder: (context, clientSnap) {
                int clientsCount = clientSnap.hasData ? clientSnap.data!.docs.length : 0;

                return Column(
                  children: [
                    _statCard("Productos", productCount),
                    _statCard("Sucursales", branchCount), // <--- Reemplazado aquí
                    _statCard("Clientes", clientsCount),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(BuildContext context, String title, String emoji, Color bgColor, Widget targetScreen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen)),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 40)),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, int count) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        trailing: Text(
          "$count",
          style: TextStyle(color: AppColors.dqRed, fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}