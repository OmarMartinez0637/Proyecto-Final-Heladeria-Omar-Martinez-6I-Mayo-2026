import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Importaciones de Providers
import 'providers/auth_provider.dart';
import 'providers/products_provider.dart';
import 'providers/tab_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/branches_provider.dart';

// Importaciones de Screens
import 'screens/intro_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_wrapper.dart';
import 'screens/admin/admin_dashboard.dart';
import 'firebase_options.dart';

void main() async {
  // Asegura la inicialización de los canales nativos antes de lanzar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        // Inicializamos el ProductsProvider y ejecutamos el stream de Firestore de inmediato
        ChangeNotifierProvider(
          create: (_) => ProductsProvider()..listenProducts(),
        ),
        ChangeNotifierProvider(
          create: (_) => TabProvider()
          ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        // Inicializamos el BranchesProvider y ejecutamos el stream de sucursales de inmediato
        ChangeNotifierProvider(
          create: (_) => BranchesProvider()..listenBranches(),
        ),
      ],
      child: MaterialApp(
        title: 'Dairy Queen App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        // Definición de la jerarquía de navegación de la app
        initialRoute: '/',
        routes: {
          '/': (context) => IntroScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeWrapper(),
          '/admin': (context) => AdminDashboard(),
        },
      ),
    );
  }
}