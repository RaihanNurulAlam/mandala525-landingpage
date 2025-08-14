// ignore_for_file: unused_element, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, depend_on_referenced_packages, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHomepageBanner(context),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    _buildIntroWithIngredientsSection(context),
                    // Widget di bawah ini akan di-render full-width
                  ],
                ),
              ),
            ),
            _buildWhyUsSection(context),
            // Widget yang sudah diubah menjadi full-width
            _buildFeatureAndBenefitSection(context),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(children: [_buildTestimonialsSection(context)]),
              ),
            ),
            _buildMarketplaceSection(context),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  // MODIFIED: Widget ini diubah total menjadi full-width dan tanpa gambar
  Widget _buildFeatureAndBenefitSection(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7EFE5), // Warna latar lembut full-width
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
          ), // Batasi lebar teks agar mudah dibaca
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Investasi Terbaik untuk Kesehatan Anda",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Susu New Mandala 525 adalah pilihan cerdas untuk menjaga kesehatan tulang dan sendi dari dalam, memberikan nutrisi yang Anda butuhkan untuk tetap aktif setiap hari.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Mengarahkan ke tab Distributor Resmi
                  widget.tabController.animateTo(4);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 18,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Beli di Distributor Resmi"),
              ),
              const SizedBox(height: 40),
              const Divider(thickness: 1),
              const SizedBox(height: 40),
              // Manfaat produk
              _buildBenefitItem(
                Icons.healing,
                'Membantu Penyembuhan & Mencegah Stroke',
              ),
              const SizedBox(height: 20),
              _buildBenefitItem(
                Icons.security_outlined,
                'Menguatkan Tulang & Mencegah Osteoporosis',
              ),
              const SizedBox(height: 20),
              _buildBenefitItem(
                Icons.favorite_border,
                'Meningkatkan Fungsi Jantung',
              ),
              // const SizedBox(height: 32),
              // Paragraf penjelasan baru
              // Text(
              //   "Manfaat-manfaat ini hadir berkat kandungan protein nabati yang tinggi untuk regenerasi sel, isoflavon sebagai antioksidan kuat yang menjaga kesehatan jantung, serta kalsium dari kedelai yang esensial untuk kepadatan tulang.",
              //   textAlign: TextAlign.center,
              //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              //     color: Colors.black54,
              //     fontStyle: FontStyle.italic,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk menampilkan item manfaat
  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildIntroWithIngredientsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;
          final imageWidget = ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/mdl2.jpg',
              height: isDesktop ? 450 : 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100),
            ),
          );
          final textAndIngredientsWidget = Column(
            crossAxisAlignment:
                isDesktop
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
            children: [
              Text(
                "Pilihan Cerdas Hidup Sehat dan Aktif",
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
                "Minuman serbuk kedelai instan yang diproses alami, mengandung protein nabati tinggi, serat, dan isoflavon. Baik untuk jantung, bantu turunkan kolesterol, dan menjaga daya tahan tubuh.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              ),
              const SizedBox(height: 32),
              const Divider(thickness: 1),
              const SizedBox(height: 32),
              _buildIngredientItemHomepage(
                context,
                Icons.eco,
                'Susu Kedelai GMO',
                'Sumber protein nabati berkualitas tinggi, baik untuk kesehatan jantung dan menjaga kepadatan tulang.',
              ),
              const SizedBox(height: 20),
              _buildIngredientItemHomepage(
                context,
                Icons.grass,
                'Daun Pandan Asli',
                'Memberikan aroma khas yang menenangkan dan mengandung antioksidan alami yang baik untuk tubuh.',
              ),
              const SizedBox(height: 32),
              Align(
                alignment: isDesktop ? Alignment.centerLeft : Alignment.center,
                child: TextButton.icon(
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
              ),
            ],
          );

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: imageWidget),
                const SizedBox(width: 50),
                Expanded(flex: 3, child: textAndIngredientsWidget),
              ],
            );
          } else {
            return Column(
              children: [
                imageWidget,
                const SizedBox(height: 40),
                textAndIngredientsWidget,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildIngredientItemHomepage(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomepageBanner(BuildContext context) {
    final List<Map<String, String>> banners = [
      {'background': 'assets/images/produk.jpeg'},
      {'background': 'assets/images/kandungan.jpeg'},
      {'background': 'assets/images/gejala.jpeg'},
    ];

    return CarouselSlider.builder(
      itemCount: banners.length,
      options: CarouselOptions(
        height: 350,
        autoPlay: banners.length > 1,
        autoPlayInterval: const Duration(seconds: 4),
        viewportFraction: 1.0,
      ),
      itemBuilder: (context, index, realIndex) {
        final banner = banners[index];
        return Stack(
          fit: StackFit.expand,
          children: [
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
          ],
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
        'image': 'assets/images/testimoni_3.jpg',
        'name': 'Bapak Telo',
        'comment':
            '"Awalnya ragu, tapi pegal di punggung jadi hilang. Sangat direkomendasikan!"',
      },
      {
        'image': 'assets/images/testimoni_4.jpg',
        'name': 'Ibu Wati',
        'comment':
            '"Tidur jadi lebih nyenyak dan bangun pagi badan terasa lebih segar. Terima kasih Mandala 525."',
      },
    ];

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
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 40),
          CarouselSlider.builder(
            itemCount: testimonies.length,
            options: CarouselOptions(
              height: 320,
              autoPlay: testimonies.length > 3,
              viewportFraction: viewportFraction,
              enlargeCenterPage: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final testimony = testimonies[index];

              return Container(
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

  Widget _buildMarketplaceSection(BuildContext context) {
    final List<Map<String, String>> marketplaces = [
      {
        'image': 'assets/images/img-shopee.jpg',
        'url': 'https://shopee.co.id/newmandala525',
      },
      {
        'image': 'assets/images/img-tokopedia.jpg',
        'url': 'https://www.tokopedia.com/newmandala525',
      },
      {
        'image': 'assets/images/img-lazada.jpg',
        'url': 'https://www.lazada.co.id/shop/new-mandala-525',
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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

  Widget _buildWhyUsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: Column(
        children: [
          Text(
            "Kenapa Harus New Mandala 525?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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

  Widget _buildFooterLink(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildFooterColumn({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);

    final Widget exploreColumn = _buildFooterColumn(
      title: "EXPLORE",
      children: [
        _buildFooterLink("Produk", () => widget.tabController.animateTo(1)),
        _buildFooterLink("Testimoni", () => widget.tabController.animateTo(2)),
      ],
    );

    final Widget shopColumn = _buildFooterColumn(
      title: "SHOP",
      children: [
        _buildFooterLink(
          "Distributor Resmi",
          () => widget.tabController.animateTo(3),
        ),
        _buildFooterLink(
          "Shopee",
          () => _launchURL('https://shopee.co.id/newmandala525'),
        ),
        _buildFooterLink(
          "Tokopedia",
          () => _launchURL('https://www.tokopedia.com/newmandala525'),
        ),
        _buildFooterLink(
          "Lazada",
          () => _launchURL('https://www.lazada.co.id/shop/new-mandala-525'),
        ),
      ],
    );

    final Widget aboutColumn = _buildFooterColumn(
      title: "ABOUT",
      children: [
        _buildFooterLink("Sejarah", () => widget.tabController.animateTo(5)),
        _buildFooterLink("Blog", () => widget.tabController.animateTo(2)),
        _buildFooterLink(
          "Kontak",
          () => _launchURL('https://wa.me/6281234567890'),
        ),
      ],
    );

    final Widget followColumn = _buildFooterColumn(
      title: "FOLLOW",
      children: [
        _buildFooterLink(
          "Instagram",
          () => _launchURL(
            'https://www.instagram.com/newmandala525_?igsh=dDUzcDR2ZHo5dWdo',
          ),
        ),
        _buildFooterLink(
          "TikTok",
          () => _launchURL(
            'https://www.tiktok.com/@newmdl525?_t=ZS-8x6zbRfI6AT&_r=1',
          ),
        ),
        _buildFooterLink(
          "YouTube",
          () => _launchURL(
            'https://youtube.com/@newmandala525?si=n98aLsVJQOvZq-10',
          ),
        ),
        _buildFooterLink(
          "Facebook",
          () => _launchURL(
            'https://www.facebook.com/share/1ASGiheM7B/?mibextid=wwXIfr',
          ),
        ),
      ],
    );

    return Container(
      color: const Color(0xFF2E4843),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 40,
        horizontal: isDesktop ? 48 : 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: exploreColumn),
                    Expanded(child: shopColumn),
                    Expanded(child: aboutColumn),
                    Expanded(child: followColumn),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [exploreColumn, shopColumn],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [aboutColumn, followColumn],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              const Divider(color: Colors.white24),
              const SizedBox(height: 24),
              Text(
                "© 2025 New Mandala 525 | Website Resmi Produk",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
