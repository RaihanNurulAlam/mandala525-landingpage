// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductContent extends StatefulWidget {
  final bool showServingMethod;
  // Konstruktor diubah untuk menerima key
  const ProductContent({super.key, required this.showServingMethod});

  @override
  // Nama State diubah agar bisa diakses secara publik oleh GlobalKey
  ProductContentState createState() => ProductContentState();
}

// Nama State diubah dari _ProductContentState menjadi ProductContentState
class ProductContentState extends State<ProductContent> {
  final _formKey = GlobalKey<FormState>();
  final _formSectionKey = GlobalKey();

  String name = '';
  String phone = '';
  String message = '';
  String quantity = '';

  // Method ini dibuat publik agar bisa dipanggil dari main.dart
  void scrollToForm() {
    if (!widget.showServingMethod && _formSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _formSectionKey.currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final fullMessage =
          'Halo, saya $name, ingin memesan New Mandala 525 sebanyak $quantity pcs. $message (No. WA: $phone)';
      final whatsAppUrl =
          'https://wa.me/6282117556907?text=${Uri.encodeComponent(fullMessage)}';
      if (await canLaunchUrl(Uri.parse(whatsAppUrl))) {
        await launchUrl(Uri.parse(whatsAppUrl));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeroSection(context),
          _buildProblemSection(context),
          _buildIntroProductSection(context),
          _buildKeyIngredientsSection(context),
          _buildTestimonialsSection(context),
          _buildCertificationSection(context),
          if (widget.showServingMethod) _buildServingMethodSection(context),
          if (!widget.showServingMethod) ...[
            _buildOrderFormSection(context),
            _buildFaqSection(context), // Penambahan FAQ
            _buildFooter(context),
          ],
        ],
      ),
    );
  }

  // --- WIDGET UNTUK FOOTER DAN IKON SOSIAL MEDIA (DIPERBAIKI) ---
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

  // --- SISA WIDGETS (TIDAK BERUBAH) ---

  Widget _buildIntroProductSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      child: Column(
        children: [
          Text(
            "PRODUK NEW MANDALA 525",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop = constraints.maxWidth > 700;

              // Widget untuk gambar
              final imageWidget = ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/mdl1.jpg',
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Icon(Icons.image, size: 100),
                ),
              );

              // Widget untuk Teks
              final textWidget = Column(
                crossAxisAlignment:
                    isDesktop
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                children: [
                  Text(
                    "New Mandala 525",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "New Mandala 525 adalah minuman multigrain dengan kedelai pilihan yang tinggi serat. Diformulasikan secara khusus untuk membantu meningkatkan kesehatan persendian dan tulang secara menyeluruh. Kandungan alaminya dapat mengoptimalkan nutrisi serta ineral yang dibutuhkan oleh tubuh.",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () {
                      // Gunakan TabController.of untuk berpindah tab
                      TabController? tabController = DefaultTabController.of(
                        context,
                      );
                      tabController.animateTo(1);
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Lihat Detail Produk"),
                  ),
                ],
              );

              // --- PERBAIKAN LOGIKA LAYOUT ---
              if (isDesktop) {
                // Untuk Desktop, gunakan Row dengan Expanded
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: textWidget),
                    const SizedBox(width: 40),
                    Expanded(child: imageWidget),
                  ],
                );
              } else {
                // Untuk Mobile, gunakan Column sederhana
                return Column(
                  children: [
                    imageWidget,
                    const SizedBox(height: 30),
                    textWidget,
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final List<Map<String, String>> testimonies = [
      {
        'image': 'assets/images/testimoni.jpg',
        'name': 'Bapak Tirtayasa',
        'comment':
            '"Setelah rutin minum Mandala 525, nyeri sendi saya jauh berkurang. Aktivitas jadi lebih nyaman!"',
      },
      {
        'image': 'assets/images/vitri.jpg',
        'name': 'Ibu Vitriani',
        'comment':
            '"Badan tidak mudah lelah dan kesemutan di tangan hilang. Produknya benar-benar terasa manfaatnya."',
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Apa Kata Mereka?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 280,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.85,
              ), // Menampilkan sebagian kartu berikutnya
              itemCount: testimonies.length,
              itemBuilder: (context, index) {
                final testimony = testimonies[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                testimony['comment']!,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(
                                  testimony['image']!,
                                ),
                                onBackgroundImageError:
                                    (exception, stackTrace) {},
                              ),
                              const SizedBox(width: 12),
                              Text(
                                testimony['name']!,
                                style: Theme.of(context).textTheme.bodyLarge
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
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final faqs = [
      {
        'q': 'Apakah New Mandala 525 aman dikonsumsi setiap hari?',
        'a':
            'Ya, New Mandala 525 sangat aman dikonsumsi setiap hari karena terbuat dari bahan-bahan alami pilihan dan sudah tersertifikasi BPOM.',
      },
      {
        'q': 'Apakah produk ini mengandung gula?',
        'a':
            'Produk kami menggunakan pemanis alami yang aman dan rendah kalori, sehingga cocok untuk Anda yang sedang menjaga asupan gula.',
      },
      {
        'q': 'Siapa saja yang boleh mengonsumsi produk ini?',
        'a':
            'Produk ini cocok dikonsumsi oleh dewasa hingga lanjut usia, terutama bagi mereka yang memiliki keluhan pada sendi, tulang, atau ingin menjaga kesehatan secara umum.',
      },
      {
        'q': 'Bagaimana cara menjadi agen resmi?',
        'a':
            'Untuk informasi pendaftaran agen, Anda dapat menghubungi nomor WhatsApp resmi kami yang tertera di halaman "Distribusi".',
      },
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      color: const Color(0xFFF7EFE5),
      child: Column(
        children: [
          Text(
            "Frequently Asked Questions (FAQ)",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          ...faqs.map(
            (faq) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 1,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                title: Text(
                  faq['q']!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(faq['a']!, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderFormSection(BuildContext context) {
    return Container(
      key: _formSectionKey,
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              Text(
                "Pesan Sekarang!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                "Isi form di bawah ini dan kami akan segera menghubungi Anda melalui WhatsApp.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                      ),
                      onSaved: (val) => name = val ?? '',
                      validator:
                          (val) =>
                              val!.isEmpty ? 'Nama tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'No. WhatsApp Aktif',
                      ),
                      keyboardType: TextInputType.phone,
                      onSaved: (val) => phone = val ?? '',
                      validator:
                          (val) =>
                              val!.isEmpty
                                  ? 'No. WhatsApp tidak boleh kosong'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Pesanan (pcs)',
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (val) => quantity = val ?? '',
                      validator:
                          (val) =>
                              val!.isEmpty ? 'Jumlah tidak boleh kosong' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Pesan Tambahan (opsional)',
                      ),
                      onSaved: (val) => message = val ?? '',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submitOrder,
                      child: const Text("Kirim Pesanan via WhatsApp"),
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

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            "SOLUSI ATASI MASALAH TULANG, SENDI & SARAF",
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/mdl2.jpg',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemSection(BuildContext context) {
    final problems = [
      "Mudah Lelah & Capek",
      "Nyeri Pada Persendian",
      "Sering Kesemutan",
      "Tulang Keropos (Osteoporosis)",
    ];
    return Container(
      color: const Color(0xFFF7EFE5),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Text(
            "Sering Mengalami Gejala Ini?",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          ...problems.map(
            (problem) => ListTile(
              leading: Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                problem,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
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
}
