// ignore_for_file: unused_element, no_leading_underscores_for_local_identifiers, use_key_in_widget_constructors, depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
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
                _buildBenefitsSection(context),
                _buildWhyUsSection(context),
                _buildIngredientsSection(context),
                _buildProductBundleSection(context),
                _buildTestimonialsSection(context),
                _buildMarketplaceSection(context),
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

  Widget _buildProductBundleSection(BuildContext context) {
    const String productImage = 'assets/images/mdl1.jpg';
    const String priceOneBox = "Rp 85.000";
    const String priceTwoBoxOriginal = "Rp 170.000";
    const String priceTwoBoxDiscount = "Rp 150.000";
    const String savings = "Hemat Rp 20.000";

    return _buildSectionCard(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 700;
          CrossAxisAlignment alignment =
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center;
          TextAlign textAlign = isDesktop ? TextAlign.start : TextAlign.center;
          final imageWidget = ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              productImage,
              width: isDesktop ? 250 : 280,
              height: isDesktop ? 250 : 280,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: isDesktop ? 250 : 280,
                    height: isDesktop ? 250 : 280,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
            ),
          );
          final detailsWidget = Column(
            crossAxisAlignment: alignment,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Penawaran Spesial!",
                textAlign: textAlign,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Dapatkan paket lebih hemat untuk kesehatan sendi Anda.",
                textAlign: textAlign,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Chip(
                label: Text(
                  '1 Box: $priceOneBox',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "2 Box: $priceTwoBoxOriginal",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                priceTwoBoxDiscount,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  savings,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  widget.tabController.animateTo(4);
                },
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text("Beli Paket Sekarang"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          );

          if (isDesktop) {
            return Row(
              children: [
                Expanded(flex: 2, child: imageWidget),
                const SizedBox(width: 40),
                Expanded(flex: 3, child: detailsWidget),
              ],
            );
          } else {
            return Column(
              children: [
                imageWidget,
                const SizedBox(height: 40),
                detailsWidget,
              ],
            );
          }
        },
      ),
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
      {'image': 'assets/images/img-shopee.jpg', 'url': 'https://shopee.co.id'},
      {
        'image': 'assets/images/img-tokopedia.jpg',
        'url': 'https://www.tokopedia.com',
      },
      {
        'image': 'assets/images/img-lazada.jpg',
        'url': 'https://www.lazada.co.id',
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
      {'icon': Icons.healing, 'text': 'Membantu Penyembuhan & Mencegah Stroke'},
      {
        'icon': Icons.security,
        'text': 'Menguatkan Tulang & Mencegah Osteoporosis',
      },
      {'icon': Icons.favorite_border, 'text': 'Meningkatkan Fungsi Jantung'},
    ];

    return _buildSectionCard(
      color: const Color(0xFFF7EFE5),
      child: Column(
        children: [
          Text(
            "Manfaat New Mandala 525",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
      child: Column(
        children: [
          Text(
            "Kandungan Utama",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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
      width: 280,
      child: Card(
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 700;

          final imageWidget = ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/mdl2.jpg',
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
                "Minuman serbuk kedelai instan yang terbuat dari kacang kedelai pilihan. Minuman ini diproses secara alami dan mengandung protein nabati yang sangat tinggi, mengandung serat, asam lemak tak jenuh, zat besi, dan isoflavon. Baik untuk jantung, bantu turunkan kolesterol, dan menjaga daya tahan tubuh.",
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
