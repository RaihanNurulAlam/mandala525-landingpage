// ignore_for_file: unnecessary_import, deprecated_member_use, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

// Kelas helper untuk layout responsif
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
}

// Mengubah menjadi StatefulWidget untuk menampung TabController
class InspirationPage extends StatefulWidget {
  final TabController tabController;
  const InspirationPage({super.key, required this.tabController});

  @override
  State<InspirationPage> createState() => _InspirationPageState();
}

class _InspirationPageState extends State<InspirationPage> {
  final List<Map<String, String>> articles = const [
    {
      'image': 'assets/images/testimoni.jpg',
      'title': 'Kisah Bapak Tirtayasa: Bangkit dari Nyeri Sendi Menahun',
      'summary':
          'Bertahun-tahun menderita nyeri sendi, Bapak Tirtayasa kini bisa kembali beraktivitas normal...',
      'content':
          'Bapak Tirtayasa, seorang pensiunan guru berusia 65 tahun, telah lama menderita nyeri sendi yang sangat mengganggu aktivitas hariannya. "Setiap mau sholat, sendi lutut saya sakit sekali," kenangnya. Setelah mencoba berbagai pengobatan, ia menemukan New Mandala 525. Dengan konsumsi rutin selama 3 bulan, perubahan signifikan ia rasakan. "Alhamdulillah, sekarang saya bisa berkebun lagi, bahkan menggendong cucu tanpa rasa sakit," ujarnya sambil tersenyum. Kisah beliau menjadi inspirasi bahwa usia bukanlah halangan untuk tetap aktif dan bebas dari nyeri sendi.',
    },
    {
      'image': 'assets/images/vitri.jpg',
      'title': 'Badan Bugar di Usia Senja, Rahasia Ibu Vitriani',
      'summary':
          'Siapa sangka di usianya yang sudah tidak muda lagi, Ibu Vitriani masih tampak bugar dan jarang sakit...',
      'content':
          'Ibu Vitriani (70 tahun) sering membuat tetangganya kagum karena vitalitasnya. Saat yang lain sering mengeluh pegal linu, beliau masih aktif mengikuti senam setiap pagi. Rahasianya ternyata sederhana: pola hidup sehat dan asupan nutrisi yang tepat. "Selain makan sayur dan buah, saya rutin minum susu kedelai yang kaya akan kalsium dan isoflavon," ungkapnya. Menurutnya, nutrisi dari kedelai membantunya menjaga kepadatan tulang dan memberikan energi yang cukup untuk beraktivitas sepanjang hari. Beliau adalah bukti nyata bahwa menjaga kesehatan sejak dini adalah investasi terbaik untuk masa tua.',
    },
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  // Ganti metode build yang lama dengan yang ini
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Body diubah menjadi Column untuk layout "sticky footer"
      body: Column(
        children: [
          // Expanded membuat konten di dalamnya mengisi semua ruang vertikal yang tersisa
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Konten utama halaman
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            "Artikel & Testimoni",
                            style: Theme.of(
                              context,
                            ).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Kisah nyata dan inspirasi dari mereka yang telah merasakan manfaatnya.",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 650) {
                                return buildColumnLayout(context);
                              } else {
                                return buildWrapLayout(context);
                              }
                            },
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer diletakkan di sini, di luar Expanded agar menempel di bawah
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget buildColumnLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            articles.map((article) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ArticleCard(article: article),
              );
            }).toList(),
      ),
    );
  }

  Widget buildWrapLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          alignment: WrapAlignment.center,
          children:
              articles.map((article) {
                return SizedBox(
                  width: 340,
                  child: ArticleCard(article: article),
                );
              }).toList(),
        ),
      ),
    );
  }

  // === WIDGET FOOTER DAN HELPER-NYA DIBAWAH INI ===

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

// Kartu Artikel dengan shadow yang lebih jelas
class ArticleCard extends StatelessWidget {
  final Map<String, String> article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              article['image']!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title']!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article['summary']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Baca Selengkapnya...",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Halaman Detail Artikel
class ArticleDetailPage extends StatelessWidget {
  final Map<String, String> article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          article['title']!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Card(
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    article['image']!,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title']!,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(thickness: 1),
                        const SizedBox(height: 24),
                        Text(
                          article['content']!,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                            height: 1.7,
                            color: Colors.black.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
