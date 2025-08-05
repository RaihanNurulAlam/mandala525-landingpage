// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Ganti dengan path halaman Anda yang sebenarnya
import 'pages/home_page.dart';
import 'pages/product_page.dart';
import 'pages/distribution_page.dart';
import 'pages/inspiration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const Mandala525App());
  } catch (e) {
    // Menampilkan pesan error jika Firebase gagal diinisialisasi
    runApp(ErrorApp(error: e.toString()));
  }
}

class ErrorApp extends StatelessWidget {
  final String? error;
  const ErrorApp({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 20),
                Text(
                  'Aplikasi sedang mengalami masalah teknis',
                  style: GoogleFonts.poppins(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Silakan coba lagi nanti.\nDetail: $error',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.poppins(),
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

// --- WIDGET MAINSCREEN DENGAN LAYOUT BARU ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();

  final List<Tab> _tabs = const [
    Tab(text: "Beranda"),
    Tab(text: "Produk"),
    Tab(text: "Edukasi"),
    Tab(text: "Artikel"),
    Tab(text: "Beli Disini"),
    Tab(text: "Kontak"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 4) {
      _buyNow();
      _tabController.animateTo(0);
    }
  }

  void _buyNow() {
    if (_tabController.index != 0) {
      _tabController.animateTo(0);
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      _homePageKey.currentState?.scrollToForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth > 800;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                // Sliver untuk Logo dan Ikon Keranjang
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/MDL525.png', height: 40),
                        IconButton(
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onPressed: _buyNow,
                          tooltip: 'Beli Sekarang',
                        ),
                      ],
                    ),
                  ),
                ),
                // Sliver untuk TabBar yang menempel (sticky)
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable:
                          !isDesktop, // true di mobile, false di desktop
                      tabs: _tabs,
                    ),
                  ),
                  pinned: true, // Membuat TabBar menempel di atas
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                HomePage(key: _homePageKey, tabController: _tabController),
                const ProductPage(),
                const InspirationPage(),
                const DistributionPage(),
                const Center(child: CircularProgressIndicator()),
                const Center(child: Text("Halaman Kontak Dalam Pengembangan")),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Class Delegate untuk membuat SliverPersistentHeader
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
