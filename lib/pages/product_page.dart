// ignore_for_file: deprecated_member_use

// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // _buildHomepageBanner(context),
              // const SizedBox(height: 30),
              _buildIntroductionSection(context),
              const SizedBox(height: 30),
              _buildKeyIngredientsSection(context),
              _buildServingMethodSection(context),
              _buildCertificationSection(context),
              _buildProductBundleSection(context),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroductionSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;

        final introDetails = Column(
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                'assets/images/mdl1.jpg',
                height: 300,
                width: isDesktop ? double.infinity : 300,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 300,
                      width: isDesktop ? double.infinity : 300,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.local_florist,
                          color: Colors.grey,
                          size: 50,
                        ),
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Apa itu New Mandala 525?",
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "Minuman serbuk kedelai instan yang terbuat dari kacang kedelai pilihan. Minuman ini diproses secara alami dan mengandung protein nabati yang sangat tinggi, mengandung serat, asam lemak tak jenuh, zat besi, dan isoflavon. Baik untuk jantung, bantu turunkan kolesterol, dan menjaga daya tahan tubuh.",
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        );

        final ingredientsList = Column(
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            if (isDesktop) const SizedBox(height: 80),
            Text(
              "Bahan Utama Pilihan",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildIngredientItem(
              context,
              Icons.eco,
              "Kedelai GMO",
              "Kaya akan protein nabati dan isoflavon untuk kesehatan tulang, jantung, dan keseimbangan hormon.",
            ),
            const SizedBox(height: 20),
            _buildIngredientItem(
              context,
              Icons.grass,
              "Daun Pandan Asli",
              "Memberikan aroma wangi alami yang menenangkan serta memiliki manfaat sebagai antioksidan.",
            ),
          ],
        );
        if (isDesktop) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: introDetails),
                const SizedBox(width: 40),
                Expanded(flex: 2, child: ingredientsList),
              ],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                introDetails,
                const SizedBox(height: 40),
                ingredientsList,
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildIngredientItem(
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

  Widget _buildKeyIngredientsSection(BuildContext context) {
    final ingredients = [
      {
        'icon': Icons.spa,
        'title': 'Protein Nabati',
        'desc':
            'Sumber kekuatan dari alam untuk menjaga massa otot dan metabolisme tubuh, agar Anda tetap aktif dan berenergi.',
      },
      {
        'icon': Icons.grass,
        'title': 'Isoflavon',
        'desc':
            'Antioksidan istimewa yang menjaga harmoni hormon, merawat jantung, serta menguatkan tulang dari dalam.',
      },
      {
        'icon': Icons.grain,
        'title': 'Lesitin Kedelai',
        'desc':
            'Nutrisi cerdas untuk otak dan jantung. Menjaga Anda tetap sehat dan bersemangat menjalani hari.',
      },
      {
        'icon': Icons.eco,
        'title': 'Serat Pangan',
        'desc':
            'Sahabat pencernaan Anda. Membantu mengontrol gula darah dan kolesterol, untuk tubuh yang terasa ringan dan ideal.',
      },
      {
        'icon': Icons.health_and_safety_outlined,
        'title': 'Vitamin & Mineral',
        'desc':
            'Pelengkap sempurna untuk daya tahan tubuh. Menjaga metabolisme dan fungsi organ agar tubuh selalu prima.',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      color: const Color(0xFFF7EFE5), // Warna latar yang lembut
      child: Column(
        children: [
          Text(
            "KANDUNGAN UTAMA",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            "Pilihan Cerdas Hidup Sehat dan Aktif",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.black54,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 24,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children:
                ingredients.map((item) {
                  return SizedBox(
                    width: 160,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Icon(
                              item['icon'] as IconData,
                              size: 40,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item['title'] as String,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['desc'] as String,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
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

  Widget _buildServingMethodSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      child: Column(
        children: [
          Text(
            "CARA PENYAJIAN",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildStep(
                    context,
                    '1',
                    'Ambil 2 sendok makan atau 20 gram New Mandala 525.',
                  ),
                  const Divider(height: 32),
                  _buildStep(context, '2', 'Seduh dengan air hangat +- 300 ml'),
                  const Divider(height: 32),
                  _buildStep(
                    context,
                    '3',
                    'Aduk hingga rata, bisa diminum dalam keadaan hangat atau dingin.',
                  ),
                  const Divider(height: 32),
                  _buildStep(
                    context,
                    '4',
                    'Campurkan dengan berbagai rasa dan aroma (sirup, coklat, madu, dll) sesuai selera.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }

  Widget _buildCertificationSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      color: const Color(0xFFF7EFE5),
      child: Center(
        child: Column(
          children: [
            Text(
              "Tersertifikasi & Terpercaya",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              "Produk kami telah terdaftar resmi, aman untuk dikonsumsi.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Image.asset(
              'assets/images/bpom_logo.png',
              height: 60,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.verified, size: 60, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: const Color(0xFF2E4843),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
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
          const SizedBox(height: 20),
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

  // Widget _buildHomepageBanner(BuildContext context) {
  //   final List<Map<String, String>> banners = [
  //     {'background': 'assets/images/produk.jpeg'},
  //     {'background': 'assets/images/kandungan.jpeg'},
  //     {'background': 'assets/images/gejala.jpeg'},
  //   ];

  //   return CarouselSlider.builder(
  //     itemCount: banners.length,
  //     options: CarouselOptions(
  //       height: 350,
  //       autoPlay: banners.length > 1,
  //       autoPlayInterval: const Duration(seconds: 4),
  //       viewportFraction: 1.0,
  //     ),
  //     itemBuilder: (context, index, realIndex) {
  //       final banner = banners[index];
  //       return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //         child: Card(
  //           margin: const EdgeInsets.symmetric(vertical: 4.0),
  //           elevation: 4,
  //           shadowColor: Colors.black.withOpacity(0.2),
  //           clipBehavior: Clip.antiAlias,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           child: Stack(
  //             fit: StackFit.expand,
  //             children: [
  //               Image.asset(
  //                 banner['background']!,
  //                 fit: BoxFit.cover,
  //                 errorBuilder:
  //                     (context, error, stackTrace) => const Center(
  //                       child: Icon(
  //                         Icons.broken_image_outlined,
  //                         color: Colors.grey,
  //                         size: 50,
  //                       ),
  //                     ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.link, color: Colors.white, size: 24);
          },
        ),
      ),
    );
  }
}
