// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
class EdukasiPage extends StatefulWidget {
  final TabController tabController;
  const EdukasiPage({super.key, required this.tabController});

  @override
  State<EdukasiPage> createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
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
        child: Column(
          children: [
            // Konten utama halaman
            LayoutBuilder(
              builder: (context, constraints) {
                final double horizontalPadding =
                    constraints.maxWidth > 800 ? 64.0 : 20.0;
                return Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 960),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 32.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            'assets/images/mdl1.jpg',
                            fit: BoxFit.cover,
                            height: 300,
                            width: double.infinity,
                            frameBuilder: (
                              context,
                              child,
                              frame,
                              wasSynchronouslyLoaded,
                            ) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                                child: child,
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 300,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        Text(
                          'Kekuatan Kedelai untuk Kesehatan Anda',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            color: const Color(0xFF2E4843),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Susu kedelai bukan hanya minuman lezat, tetapi juga sumber nutrisi luar biasa yang telah terbukti secara ilmiah memberikan banyak manfaat bagi tubuh. Dari jantung hingga tulang, inilah kekuatan tersembunyi di setiap tetesnya.',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            height: 1.6,
                            color: Colors.black.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        const Divider(thickness: 1),
                        const SizedBox(height: 24.0),
                        const BenefitItem(
                          icon: Icons.healing,
                          title: 'Membantu Penyembuhan & Mencegah Stroke',
                          description:
                              'Kandungan isoflavon dan antioksidan dalam kedelai dapat membantu memperbaiki pembuluh darah dan mengurangi peradangan. Ini berperan penting dalam proses pemulihan pasca-stroke sekaligus mengurangi faktor risiko terjadinya stroke berulang.',
                        ),
                        const BenefitItem(
                          icon: Icons.security,
                          title: 'Menguatkan Tulang & Mencegah Osteoporosis',
                          description:
                              'Kedelai kaya akan isoflavon yang strukturnya mirip estrogen, membantu menjaga kepadatan mineral tulang. Konsumsi rutin sangat dianjurkan untuk wanita pasca-menopause guna mencegah pengeroposan tulang atau osteoporosis.',
                        ),
                        const BenefitItem(
                          icon: Icons.favorite_border,
                          title: 'Meningkatkan Fungsi Jantung',
                          description:
                              'Lemak tak jenuh, serat, dan protein dalam kedelai efektif menurunkan kadar kolesterol jahat (LDL) dalam darah. Ini menjaga arteri tetap bersih dan elastis, sehingga mengurangi risiko penyakit jantung koroner.',
                        ),
                        const BenefitItem(
                          icon: Icons.local_drink_outlined,
                          title: 'Manfaat Konsumsi Rutin',
                          description:
                              'Meminum susu kedelai secara teratur dapat meningkatkan kesehatan kulit karena kandungan antioksidannya, membantu menjaga berat badan ideal karena tinggi protein dan serat, serta memberikan energi yang stabil sepanjang hari.',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Footer yang sama dengan homepage ditambahkan di sini
            _buildFooter(context),
          ],
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

class BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BenefitItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color textColor = const Color(0xFF2E4843);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 40),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    height: 1.5,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
