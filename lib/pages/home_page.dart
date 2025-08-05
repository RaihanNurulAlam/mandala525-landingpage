// ignore_for_file: unused_element, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, depend_on_referenced_packages, deprecated_member_use

// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart'; // <-- IMPORT PACKAGE BARU

// Helper class untuk mempermudah penanganan responsivitas
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
}

class HomePage extends StatefulWidget {
  final TabController tabController;
  const HomePage({super.key, required this.tabController});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey _formSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void scrollToForm() {
    if (_formSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _formSectionKey.currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  // Helper untuk membuka URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Bisa ditambahkan snackbar atau dialog jika URL gagal dibuka
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildHomepageBanner(context),
                _buildIntroProductSection(context),
                // _buildProblemSection(context),
                _buildBenefitsSection(context),
                _buildWhyUsSection(context),
                _buildIngredientsSection(context),
                _buildTestimonialsSection(context),

                // --- WIDGET BARU DITAMBAHKAN DI SINI ---
                // _buildArticlesSection(context),
                _buildMarketplaceSection(context),
                // --- AKHIR DARI WIDGET BARU ---

                // _buildOrderFormSection(context, _formSectionKey),
                // _buildFaqSection(context),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required Widget child,
    Color? color,
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Card(
        color: color ?? Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.15),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
          child: child,
        ),
      ),
    );
  }

  // --- WIDGET BANNER BARU SESUAI PERMINTAAN ---
  Widget _buildHomepageBanner(BuildContext context) {
    // Data disederhanakan agar sesuai dengan layout baru
    final List<Map<String, String>> banners = [
      {
        'background': 'assets/images/produk.jpeg', // Ganti dengan gambar Anda
        // 'title': 'Lebih Kuat Kejar Pahala',
        // 'description': 'Dengan rutin minum Etawalin saat sahur dan berbuka.',
      },
      {
        'background':
            'assets/images/kandungan.jpeg', // Ganti dengan gambar Anda
        // 'title': 'Jaga Kesehatan Sendi & Tulang',
        // 'description': 'Solusi herbal untuk masalah persendian Anda.',
      },
      {
        'background': 'assets/images/gejala.jpeg', // Ganti dengan gambar Anda
        // 'title': 'Promo Spesial Hari Ini',
        // 'description': 'Dapatkan penawaran terbaik hanya untuk Anda.',
      },
    ];

    return CarouselSlider.builder(
      itemCount: banners.length,
      options: CarouselOptions(
        height: 350,
        autoPlay: banners.length > 1, // Autoplay hanya jika banner lebih dari 1
        autoPlayInterval: const Duration(seconds: 4),
        viewportFraction: 1.0, // Setiap banner mengisi lebar penuh
      ),
      itemBuilder: (context, index, realIndex) {
        final banner = banners[index];
        // Padding dipindahkan ke luar Card agar tidak ikut berputar
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.2),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Gambar Latar
                Image.asset(
                  banner['background']!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                ),
                // Gradient Hitam di bagian bawah
                // DecoratedBox(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.bottomCenter,
                //       end: Alignment.center,
                //       colors: [
                //         Colors.black.withOpacity(0.7),
                //         Colors.transparent,
                //       ],
                //     ),
                //   ),
                // ),
                // // Teks Judul dan Deskripsi
                // Positioned(
                //   bottom: 20.0,
                //   left: 20.0,
                //   right: 20.0,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         banner['title']!,
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 22,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       const SizedBox(height: 8.0),
                //       Text(
                //         banner['description']!,
                //         style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 14,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final List<Map<String, String>> testimonies = [
      {
        'image': 'assets/images/testimoni.jpg',
        'name': 'Bapak Tirtayasa',
        'comment':
            '"Nyeri sendi saya jauh berkurang setelah rutin minum ini. Aktivitas jadi lebih nyaman!"',
      },
      {
        'image': 'assets/images/vitri.jpg',
        'name': 'Ibu Vitriani',
        'comment':
            '"Badan tidak mudah lelah dan kesemutan di tangan hilang. Produknya benar-benar terasa."',
      },
      {
        'image': 'assets/images/testimoni_3.jpg', // Pastikan path gambar benar
        'name': 'Bapak Telo',
        'comment':
            '"Awalnya ragu, tapi pegal di punggung jadi hilang. Sangat direkomendasikan!"',
      },
      {
        'image': 'assets/images/testimoni_4.jpg', // Pastikan path gambar benar
        'name': 'Ibu Wati',
        'comment':
            '"Tidur jadi lebih nyenyak dan bangun pagi badan terasa lebih segar. Terima kasih Mandala 525."',
      },
    ];

    // ### KUNCI PERUBAHAN DI SINI: (1/3) untuk menampilkan 3 item ###
    // Jika mobile: 1.0 (1 item penuh).
    // Jika desktop/tablet: 1/3 (sepertiga layar, jadi 3 item pas).
    final double viewportFraction =
        Responsive.isMobile(context) ? 1.0 : (1 / 3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Apa Kata Mereka?",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),

          CarouselSlider.builder(
            itemCount: testimonies.length,
            options: CarouselOptions(
              height: 320,

              // Autoplay jika item lebih dari 3 (karena 3 sudah tampil)
              autoPlay: testimonies.length > 3,

              // Menggunakan nilai viewportFraction yang baru
              viewportFraction: viewportFraction,

              // Tetap false agar tidak ada efek zoom/terpotong
              enlargeCenterPage: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final testimony = testimonies[index];

              return Container(
                // Sedikit mengurangi margin agar card lebih lega
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Card(
                  color: Colors.white,
                  elevation: 6,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              testimony['comment']!,
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage(testimony['image']!),
                              onBackgroundImageError: (e, s) {},
                            ),
                            const SizedBox(width: 16),
                            Text(
                              testimony['name']!,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =======================================================================
  // ====================== WIDGET BARU DIMULAI DARI SINI ==================
  // =======================================================================

  /// WIDGET BAGIAN ARTIKEL
  // Widget _buildArticlesSection(BuildContext context) {
  //   //
  //   // ### PERHATIAN ###
  //   // Ganti path gambar dan URL tujuan sesuai kebutuhan Anda.
  //   // Pastikan gambar sudah ditambahkan di folder assets/images/
  //   //
  //   final List<Map<String, String>> articles = [
  //     {
  //       'image': 'assets/images/artikel1.jpg',
  //       'title': 'Contoh1',
  //       'url': '#', // Ganti dengan URL artikel
  //     },
  //     {
  //       'image': 'assets/images/artikel2.jpg',
  //       'title': 'Contoh2',
  //       'url': '#', // Ganti dengan URL artikel
  //     },
  //     {
  //       'image': 'assets/images/artikel3.jpg',
  //       'title': 'contoh3',
  //       'url': '#', // Ganti dengan URL artikel
  //     },
  //   ];

  //   // Layout berbeda untuk mobile dan desktop/tablet
  //   bool isMobile = Responsive.isMobile(context);

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
  //     child: Column(
  //       children: [
  //         // Header (Judul dan Tombol)
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 20),
  //               child: Text(
  //                 "Artikel Terbaru",
  //                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 // Arahkan ke halaman daftar artikel jika ada
  //                 widget.tabController.animateTo(
  //                   3,
  //                 ); // Asumsi tab Artikel ada di index 3
  //               },
  //               child: const Text("Lihat Semua Artikel"),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 24),

  //         // Daftar Kartu Artikel
  //         isMobile
  //             ? SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Row(
  //                 children:
  //                     articles.map((article) {
  //                       return SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.8,
  //                         child: _buildArticleCard(article),
  //                       );
  //                     }).toList(),
  //               ),
  //             )
  //             : Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children:
  //                   articles.map((article) {
  //                     return Expanded(child: _buildArticleCard(article));
  //                   }).toList(),
  //             ),
  //       ],
  //     ),
  //   );
  // }

  /// Helper widget untuk satu kartu artikel
  Widget _buildArticleCard(Map<String, String> article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            // Aksi saat kartu diklik, misalnya membuka URL
            // _launchURL(article['url']!);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Artikel
              Image.asset(
                article['image']!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    ),
              ),
              // Konten Teks
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag informasi
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        "INFORMASI PRODUK",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Judul Artikel
                    Text(
                      article['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    // Ikon panah
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// WIDGET BAGIAN MARKETPLACE
  Widget _buildMarketplaceSection(BuildContext context) {
    //
    // ### PERHATIAN ###
    // Ganti path gambar dan URL tujuan sesuai kebutuhan Anda.
    // Pastikan logo marketplace sudah ditambahkan di folder assets/images/
    //
    final List<Map<String, String>> marketplaces = [
      {
        'image': 'assets/images/img-shopee.jpg',
        'url': 'https://shopee.co.id', // Ganti dengan URL toko Anda
      },
      {
        'image': 'assets/images/img-tokopedia.jpg',
        'url': 'https://www.tokopedia.com', // Ganti dengan URL toko Anda
      },
      {
        'image': 'assets/images/img-lazada.jpg',
        'url': 'https://www.lazada.co.id', // Ganti dengan URL toko Anda
      },
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Text(
            "Belanja Susu New Mandala 525",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Dapatkan susu New Mandala 525 di berbagai marketplace kesayangan anda",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24.0,
            runSpacing: 24.0,
            alignment: WrapAlignment.center,
            children:
                marketplaces.map((item) {
                  return InkWell(
                    onTap: () => _launchURL(item['url']!),
                    child: Image.asset(
                      item['image']!,
                      height: 100,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 100,
                            width: 150,
                            color: Colors.grey.shade200,
                            child: Center(child: Text(item['image']!)),
                          ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return CircleAvatar(
      backgroundColor: Colors.black.withOpacity(0.3),
      radius: 24,
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    final benefits = [
      {'icon': Icons.healing, 'text': 'Membantu Penyembuhan Stroke'},
      {'icon': Icons.security, 'text': 'Mencegah Risiko Stroke'},
      {'icon': Icons.fitness_center, 'text': 'Menguatkan Tulang'},
      {'icon': Icons.shield_outlined, 'text': 'Cegah Osteoporosis'},
      {'icon': Icons.favorite_border, 'text': 'Meningkatkan Fungsi Jantung'},
    ];

    return _buildSectionCard(
      color: const Color(0xFFF7EFE5), // Warna krem dari desain lama
      child: Column(
        children: [
          Text(
            "Manfaat New Mandala 525",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children:
                benefits.map((benefit) {
                  return SizedBox(
                    width: 160,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.1),
                          child: Icon(
                            benefit['icon'] as IconData,
                            size: 35,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          benefit['text'] as String,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  // Widget _buildProblemSection(BuildContext context) {
  //   final problems = [
  //     "Mudah Lelah & Capek",
  //     "Nyeri Pada Persendian",
  //     "Sering Kesemutan",
  //     "Tulang Keropos (Osteoporosis)",
  //   ];
  //   return _buildSectionCard(
  //     color: const Color(0xFFF7EFE5),
  //     child: Column(
  //       children: [
  //         Text(
  //           "Sering Mengalami Gejala Ini?",
  //           textAlign: TextAlign.center,
  //           style: Theme.of(
  //             context,
  //           ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 32),
  //         ...problems.map(
  //           (problem) => ListTile(
  //             contentPadding: const EdgeInsets.symmetric(
  //               vertical: 8.0,
  //               horizontal: 16.0,
  //             ),
  //             leading: Icon(
  //               Icons.check_circle_outline,
  //               size: 30,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //             title: Text(
  //               problem,
  //               style: Theme.of(context).textTheme.titleLarge,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildWhyUsSection(BuildContext context) {
    // Menghapus _buildSectionCard dan menggantinya dengan Padding.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Column(
        children: [
          Text(
            "Kenapa Harus New Mandala 525?",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 0,
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Text(
                "Penjelasan mengenai keunggulan produk New Mandala 525 akan segera ditambahkan di sini. Kami sedang menyiapkan konten terbaik untuk Anda!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(BuildContext context) {
    final List<Map<String, String>> ingredients = [
      {
        'image': 'assets/images/kedelai.png',
        'title': 'Susu Kedelai GMO',
        'description':
            'Sumber protein nabati berkualitas tinggi, baik untuk kesehatan jantung dan menjaga kepadatan tulang.',
      },
      {
        'image': 'assets/images/pandan.png',
        'title': 'Daun Pandan',
        'description':
            'Memberikan aroma khas yang menenangkan dan mengandung antioksidan alami yang baik untuk tubuh.',
      },
    ];

    return Container(
      width: double.infinity,
      // DIKEMBALIKAN: baris 'color: Colors.white' dihapus dari sini
      // agar latar belakangnya kembali transparan (mengikuti warna utama halaman)
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Column(
        children: [
          Text(
            "Kandungan Utama",
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            "Perpaduan bahan alami terbaik untuk kesehatan Anda.",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            alignment: WrapAlignment.center,
            children:
                ingredients.map((item) => _buildIngredientCard(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientCard(Map<String, String> ingredient) {
    return SizedBox(
      width: 280, // Memberi lebar tetap pada kartu
      child: Card(
        // BARU: Tambahkan 'color: Colors.white' di sini
        // untuk memastikan kartu bahan spesifik ini berwarna putih.
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                ingredient['image']!,
                height: 60,
                width: 60,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) =>
                        const Icon(Icons.grass, size: 60, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                ingredient['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ingredient['description']!,
                style: TextStyle(color: Colors.grey.shade700, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroProductSection(BuildContext context) {
    // Menghapus _buildSectionCard dan menggantinya dengan Padding
    // untuk menjaga jarak tanpa menggunakan Card.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 700;

          final imageWidget = ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/mdl1.jpg',
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100),
            ),
          );

          final textWidget = Column(
            crossAxisAlignment:
                isDesktop
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "PRODUK NEW MANDALA 525",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "New Mandala 525",
                textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text(
                "New Mandala 525 adalah minuman multigrain dengan kedelai pilihan yang tinggi serat. Diformulasikan secara khusus untuk membantu meningkatkan kesehatan persendian dan tulang secara menyeluruh.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () {
                  widget.tabController.animateTo(1);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Lihat Detail Produk"),
              ),
            ],
          );

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: textWidget),
                const SizedBox(width: 50),
                Expanded(flex: 2, child: imageWidget),
              ],
            );
          } else {
            return Column(
              children: [imageWidget, const SizedBox(height: 40), textWidget],
            );
          }
        },
      ),
    );
  }

  // Widget _buildOrderFormSection(BuildContext context, GlobalKey formKey) {
  //   final _formStateKey = GlobalKey<FormState>();
  //   String name = '', phone = '', message = '', quantity = '';

  //   Future<void> _submitOrder() async {
  //     if (_formStateKey.currentState!.validate()) {
  //       _formStateKey.currentState!.save();
  //       final fullMessage =
  //           'Halo, saya $name, ingin memesan New Mandala 525 sebanyak $quantity pcs. $message (No. WA: $phone)';
  //       final whatsAppUrl =
  //           'https://wa.me/6282117556907?text=${Uri.encodeComponent(fullMessage)}';
  //       if (await canLaunchUrl(Uri.parse(whatsAppUrl))) {
  //         await launchUrl(Uri.parse(whatsAppUrl));
  //       }
  //     }
  //   }

  //   return _buildSectionCard(
  //     child: Center(
  //       key: formKey,
  //       child: ConstrainedBox(
  //         constraints: const BoxConstraints(maxWidth: 500),
  //         child: Column(
  //           children: [
  //             Text(
  //               "Pesan Sekarang!",
  //               style: Theme.of(
  //                 context,
  //               ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 16),
  //             Text(
  //               "Isi form di bawah ini dan kami akan segera menghubungi Anda melalui WhatsApp.",
  //               textAlign: TextAlign.center,
  //               style: Theme.of(
  //                 context,
  //               ).textTheme.titleLarge?.copyWith(color: Colors.black54),
  //             ),
  //             const SizedBox(height: 32),
  //             Form(
  //               key: _formStateKey,
  //               child: Column(
  //                 children: [
  //                   TextFormField(
  //                     decoration: const InputDecoration(
  //                       labelText: 'Nama Lengkap',
  //                     ),
  //                     onSaved: (val) => name = val ?? '',
  //                     validator:
  //                         (val) =>
  //                             val!.isEmpty ? 'Nama tidak boleh kosong' : null,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextFormField(
  //                     decoration: const InputDecoration(
  //                       labelText: 'No. WhatsApp Aktif',
  //                     ),
  //                     keyboardType: TextInputType.phone,
  //                     onSaved: (val) => phone = val ?? '',
  //                     validator:
  //                         (val) =>
  //                             val!.isEmpty
  //                                 ? 'No. WhatsApp tidak boleh kosong'
  //                                 : null,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextFormField(
  //                     decoration: const InputDecoration(
  //                       labelText: 'Jumlah Pesanan (pcs)',
  //                     ),
  //                     keyboardType: TextInputType.number,
  //                     onSaved: (val) => quantity = val ?? '',
  //                     validator:
  //                         (val) =>
  //                             val!.isEmpty ? 'Jumlah tidak boleh kosong' : null,
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextFormField(
  //                     decoration: const InputDecoration(
  //                       labelText: 'Pesan Tambahan (opsional)',
  //                     ),
  //                     onSaved: (val) => message = val ?? '',
  //                     maxLines: 3,
  //                   ),
  //                   const SizedBox(height: 40),
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 48,
  //                         vertical: 16,
  //                       ),
  //                       textStyle: Theme.of(context).textTheme.titleMedium
  //                           ?.copyWith(fontWeight: FontWeight.bold),
  //                     ),
  //                     onPressed: _submitOrder,
  //                     child: const Text("Kirim Pesanan via WhatsApp"),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildFaqSection(BuildContext context) {
  //   final faqs = [
  //     {
  //       'q': 'Apakah New Mandala 525 aman dikonsumsi setiap hari?',
  //       'a':
  //           'Ya, New Mandala 525 sangat aman dikonsumsi setiap hari karena terbuat dari bahan-bahan alami pilihan dan sudah tersertifikasi BPOM.',
  //     },
  //     {
  //       'q': 'Apakah produk ini mengandung gula?',
  //       'a':
  //           'Produk kami menggunakan pemanis alami yang aman dan rendah kalori, sehingga cocok untuk Anda yang sedang menjaga asupan gula.',
  //     },
  //     {
  //       'q': 'Siapa saja yang boleh mengonsumsi produk ini?',
  //       'a':
  //           'Produk ini cocok dikonsumsi oleh dewasa hingga lanjut usia, terutama bagi mereka yang memiliki keluhan pada sendi, tulang, atau ingin menjaga kesehatan secara umum.',
  //     },
  //     {
  //       'q': 'Bagaimana cara menjadi agen resmi?',
  //       'a':
  //           'Untuk informasi pendaftaran agen, Anda dapat menghubungi nomor WhatsApp resmi kami yang tertera di halaman "Distribusi".',
  //     },
  //   ];
  //   return _buildSectionCard(
  //     color: const Color(0xFFF7EFE5),
  //     padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
  //     child: Column(
  //       children: [
  //         Text(
  //           "Frequently Asked Questions",
  //           textAlign: TextAlign.center,
  //           style: Theme.of(
  //             context,
  //           ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 32),
  //         ...faqs.map(
  //           (faq) => Card(
  //             margin: const EdgeInsets.only(bottom: 12),
  //             elevation: 2,
  //             shadowColor: Colors.black.withOpacity(0.05),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: ExpansionTile(
  //               tilePadding: const EdgeInsets.symmetric(
  //                 horizontal: 20,
  //                 vertical: 8,
  //               ),
  //               title: Text(
  //                 faq['q']!,
  //                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //               ),
  //               childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
  //               children: [
  //                 Text(
  //                   faq['a']!,
  //                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                         color: Colors.black87,
  //                         height: 1.5,
  //                       ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: const Color(0xFF2E4843),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                'assets/images/facebook.png',
                'https://www.facebook.com/share/1ASGiheM7B/?mibextid=wwXIfr',
              ),
              _buildSocialIcon(
                'assets/images/instagram.png',
                'https://www.instagram.com/newmandala525_?igsh=dDUzcDR2ZHo5dWdo',
              ),
              _buildSocialIcon(
                'assets/images/yutub.png',
                'https://youtube.com/@newmandala525?si=n98aLsVJQOvZq-10',
              ),
              _buildSocialIcon(
                'assets/images/tiktok.png',
                'https://www.tiktok.com/@newmdl525?_t=ZS-8x6zbRfI6AT&_r=1',
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "© 2025 New Mandala 525 | Website Resmi Produk",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, String linkUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: () async {
          if (await canLaunchUrl(Uri.parse(linkUrl))) {
            await launchUrl(
              Uri.parse(linkUrl),
              mode: LaunchMode.externalApplication,
            );
          }
        },
        child: Image.asset(
          assetPath,
          width: 40,
          height: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.link, color: Colors.white, size: 24);
          },
        ),
      ),
    );
  }
}
