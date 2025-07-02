// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // File ini akan di-generate oleh FlutterFire CLI

// Impor file-file halaman yang sudah dipisahkan
import 'pages/home_content.dart';
import 'pages/distribution_page.dart';
import 'pages/inspiration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const Mandala525App());
  } catch (e) {
    // Fallback jika Firebase gagal diinisialisasi
    runApp(const ErrorApp());
  }
}

// Widget fallback jika Firebase gagal diinisialisasi
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Aplikasi sedang mengalami masalah teknis',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text('Silakan coba lagi nanti'),
            ],
          ),
        ),
      ),
    );
  }
}

// --- MAIN APP & THEME ---

class Mandala525App extends StatelessWidget {
  const Mandala525App({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF25C19);
    const textColor = Color(0xFF2E4843);
    const backgroundColor = Color(0xFFFFFBF7);

    return MaterialApp(
      title: 'New Mandala 525',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        primaryColor: primaryColor,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.grey.shade200,
          iconTheme: const IconThemeData(color: textColor),
          titleTextStyle: GoogleFonts.poppins(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: primaryColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          labelStyle: GoogleFonts.poppins(color: textColor),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
          headlineMedium: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          titleLarge: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          bodyLarge: GoogleFonts.poppins(
            color: textColor,
            fontSize: 16,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.poppins(color: Colors.black54, fontSize: 14),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// --- MAIN SCREEN with Top Tab Navigation ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ProductContentState> _homeContentKey =
      GlobalKey<ProductContentState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _buyNow() {
    _tabController.animateTo(0);
    Future.delayed(const Duration(milliseconds: 100), () {
      _homeContentKey.currentState?.scrollToForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/MDL525.png', height: 40),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: _buyNow,
            tooltip: 'Beli Sekarang',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "Home"),
            Tab(text: "Produk"),
            Tab(text: "Distribusi"),
            Tab(text: "Inspirasi"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProductContent(key: _homeContentKey, showServingMethod: false),
          ProductContent(showServingMethod: true),
          const DistributionPage(),
          const InspirationPage(),
        ],
      ),
    );
  }
}
