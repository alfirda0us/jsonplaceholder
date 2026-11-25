import 'package:flutter/material.dart';
import 'package:jsonplaceholder/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF5B5BD6);
    const secondaryColor = Color(0xFF8B5CF6);

    return MaterialApp(
      title: 'Nexa API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          secondary: secondaryColor,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: Color(0xFFE8EBF2)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          centerTitle: false,
          surfaceTintColor: Colors.transparent,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE8EBF2),
          thickness: 1,
        ),
      ),
      home: const HomePage(),
    );
  }
}
