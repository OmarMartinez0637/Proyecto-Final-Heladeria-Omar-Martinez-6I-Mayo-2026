import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tab_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'category_products_screen.dart';
import 'cart_screen.dart';
import 'branches_screen.dart'; // Importamos la pantalla de sucursales

class HomeWrapper extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    CategoryProductsScreen(category: "Helados"),
    CategoryProductsScreen(category: "Blizzards"),
    CategoryProductsScreen(category: "Bebidas"),
    CategoryProductsScreen(category: "Pasteles"),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final tabProv = context.watch<TabProvider>();
    final selectedIndex = tabProv.currentIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      // 1. AGREGAMOS EL MENÚ DESPLEGABLE (DRAWER)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.dqRed),
              child: Text("Menú DQ", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              leading: Icon(Icons.store, color: AppColors.dqBlue),
              title: Text("Ver Sucursales"),
              onTap: () {
                Navigator.pop(context); // Cierra el menú
                // Navegamos a una pantalla completa de sucursales
                Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: AppBar(title: Text("Sucursales DQ")),
                  body: BranchesScreen(),
                )));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.grey),
              title: Text("Cerrar Sesión"),
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        // 2. CORREGIMOS EL BOTÓN PARA ABRIR EL MENU
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text("DQ", style: TextStyle(color: AppColors.dqRed, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/admin'),
            child: Text("Admin", style: TextStyle(color: AppColors.dqBlue, fontWeight: FontWeight.bold)),
          ),
          IconButton(icon: Icon(Icons.person_outline, color: Colors.black), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(), // Hace el scroll más suave en iOS/Android
            child: Row(
              children: [
                _navItem(context, "Inicio", 0, selectedIndex),
                _navItem(context, "Helados", 1, selectedIndex),
                _navItem(context, "Blizzards", 2, selectedIndex),
                _navItem(context, "Bebidas", 3, selectedIndex),
                _navItem(context, "Pasteles", 4, selectedIndex),
                _navItem(context, "Carrito", 5, selectedIndex),
              ],
            ),
          ),
        ),
      ),
      body: _screens[selectedIndex],
    );
  }

  Widget _navItem(BuildContext context, String title, int index, int selectedIndex) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => context.read<TabProvider>().setIndex(index), // Cambia globalmente
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? AppColors.dqRed : Colors.transparent, width: 3)),
        ),
        child: Text(
          title, 
          style: TextStyle(
            color: isSelected ? AppColors.dqRed : Colors.black, 
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
          ),
        ),
      ),
    );
  }
}