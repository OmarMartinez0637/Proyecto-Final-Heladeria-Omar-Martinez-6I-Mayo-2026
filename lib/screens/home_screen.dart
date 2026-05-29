import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/tab_provider.dart'; // <--- Importante
import '../utils/constants.dart';
import 'category_products_screen.dart'; // Para abrir el detalle del producto nuevo

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsProv = context.watch<ProductsProvider>();
    final latest = productsProv.latestProduct;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner Principal (Rojo a Rosa)
          Container(
            height: 180,
            width: double.infinity,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: AppColors.bannerPrincipal,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text("🍦", style: TextStyle(fontSize: 80))),
          ),

          // Banner Producto Nuevo (Naranja a Rojo)
          if (latest != null)
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                gradient: AppColors.bannerNuevo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Prueba el nuevo: ${latest.name}", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(latest.description, style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 15),
                  ElevatedButton(
                    // 1. ARREGLADO: Abre la pantalla de detalle del último producto
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailScreen(product: latest)),
                      );
                    },
                    child: Text("Ver detalle"),
                  )
                ],
              ),
            ),

          SizedBox(height: 20),

          // Categorías Lilas con sus índices correctos correspondientes al Navbar
          _categoryTile(context, "Helados", "🍦", 1),
          _categoryTile(context, "Blizzards", "🍧", 2),
          _categoryTile(context, "Bebidas", "🥤", 3),
          _categoryTile(context, "Pasteles", "🎂", 4),
        ],
      ),
    );
  }

  Widget _categoryTile(BuildContext context, String title, String emoji, int tabIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lilaBg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: TextStyle(fontSize: 30)),
              Text("Conoce nuestros $title", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.dqRed),
            // 2. ARREGLADO: Te redirige de inmediato a la pestaña correcta de la barra de navegación
            onPressed: () {
              context.read<TabProvider>().setIndex(tabIndex);
            },
            child: Icon(Icons.arrow_forward),
          )
        ],
      ),
    );
  }
}