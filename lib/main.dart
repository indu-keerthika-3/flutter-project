import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/order_confirmation_screen.dart'; // maps to '/order'

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pretty Petals',

        // Keep home (entry point)
        home: const LoginScreen(),

        // Named routes (DO NOT include '/' because `home` is set)
        routes: {
          '/dashboard': (ctx) => const DashboardScreen(),
          '/order': (ctx) => const OrderConfirmationScreen(),
          // add other named routes here
        },

        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(0xFFF8BBD9, {
              50: Color(0xFFFCE4EC),
              100: Color(0xFFF8BBD9),
              200: Color(0xFFF48FB1),
              300: Color(0xFFF06292),
              400: Color(0xFFEC407A),
              500: Color(0xFFE91E63),
              600: Color(0xFFD81B60),
              700: Color(0xFFC2185B),
              800: Color(0xFFAD1457),
              900: Color(0xFF880E4F),
            }),
          ).copyWith(secondary: const Color(0xFF00695C)),
          primaryColor: const Color(0xFFF8BBD9),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF8BBD9),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Color(0xFF00695C),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Color(0xFF00695C)),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF8BBD9),
              foregroundColor: const Color(0xFF00695C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF00695C)),
            titleLarge: TextStyle(color: Color(0xFFF8BBD9)),
          ),
        ),
      ),
    );
  }
}
