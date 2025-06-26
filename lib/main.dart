// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Impor file-file halaman yang sudah dipisahkan
import 'pages/home_content.dart';
import 'pages/distribution_page.dart';
import 'pages/inspiration_page.dart';

// --- MAIN APP & THEME ---
void main() => runApp(const Mandala525App());

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
// Diubah menjadi StatefulWidget untuk mengelola TabController dan GlobalKey
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // GlobalKey untuk mengakses method dari ProductContentState
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
    // Pindah ke tab Home (index 0)
    _tabController.animateTo(0);
    // Setelah sedikit jeda agar tab sempat berpindah, panggil fungsi scroll
    Future.delayed(const Duration(milliseconds: 100), () {
      _homeContentKey.currentState?.scrollToForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController tidak lagi dibutuhkan karena kita mengelola controller secara manual
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/MDL525.png', height: 40),
        actions: [
          // Tombol "Beli Sekarang" dengan ikon keranjang belanja
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: _buyNow,
            tooltip: 'Beli Sekarang',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController, // Menggunakan controller yang kita buat
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
        controller: _tabController, // Menggunakan controller yang kita buat
        children: [
          // Memberikan key ke ProductContent agar bisa diakses
          ProductContent(key: _homeContentKey, showServingMethod: false),
          ProductContent(showServingMethod: true),
          const DistributionPage(),
          const InspirationPage(),
        ],
      ),
    );
  }
}
