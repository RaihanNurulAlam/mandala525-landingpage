// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildKeyIngredientsSection(context),
          _buildServingMethodSection(context),
          _buildCertificationSection(context),
          _buildFooter(context), // Footer bisa digunakan lagi di sini
        ],
      ),
    );
  }

  // --- WIDGET-WIDGET KONTEN UNTUK HALAMAN PRODUK ---

  Widget _buildKeyIngredientsSection(BuildContext context) {
    final ingredients = [
      {
        'icon': Icons.spa,
        'title': 'Protein Nabati',
        'desc':
            'Kaya akan protein untuk membangun dan memperbaiki sel tubuh yang rusak.',
      },
      {
        'icon': Icons.grass,
        'title': 'Isoflavon',
        'desc':
            'Sebagai antioksidan kuat yang membantu menjaga kesehatan jantung dan pembuluh darah.',
      },
      {
        'icon': Icons.grain,
        'title': 'Lesitin Kedelai',
        'desc':
            'Nutrisi penting untuk memelihara fungsi otak, saraf, dan juga kesehatan hati.',
      },
      {
        'icon': Icons.eco,
        'title': 'Serat Pangan',
        'desc':
            'Membantu melancarkan sistem pencernaan dan menjaga kadar gula darah.',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      color: const Color(0xFFF7EFE5),
      child: Column(
        children: [
          Text(
            "KANDUNGAN UTAMA",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children:
                ingredients.map((item) {
                  return SizedBox(
                    width: 150,
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
                          ).textTheme.titleLarge?.copyWith(fontSize: 18),
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
                    'Tuangkan 1 sachet New Mandala 525 ke dalam gelas.',
                  ),
                  const Divider(height: 32),
                  _buildStep(
                    context,
                    '2',
                    'Tambahkan 150ml air hangat (jangan air panas mendidih).',
                  ),
                  const Divider(height: 32),
                  _buildStep(
                    context,
                    '3',
                    'Aduk hingga rata dan minuman siap dinikmati.',
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
