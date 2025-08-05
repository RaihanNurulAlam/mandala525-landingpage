// ignore_for_file: unnecessary_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui'; // Diperlukan untuk BackdropFilter

// Halaman Inspirasi / Daftar Artikel
class InspirationPage extends StatelessWidget {
  const InspirationPage({super.key});

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
    {
      'image': 'assets/images/inspiration3.jpg',
      'title': 'Pentingnya Menjaga Kesehatan Tulang Sejak Dini',
      'summary':
          'Osteoporosis bukanlah penyakit orang tua saja. Pelajari cara mencegahnya dan pentingnya nutrisi dari kedelai.',
      'content':
          'Banyak yang mengira osteoporosis atau pengeroposan tulang hanya menyerang lansia. Faktanya, kesehatan tulang dibangun sejak masa muda. Kurangnya asupan kalsium dan vitamin D di usia produktif dapat mempercepat risiko osteoporosis di kemudian hari. Salah satu sumber nutrisi terbaik untuk tulang adalah kedelai. Kedelai mengandung isoflavon, senyawa yang strukturnya mirip estrogen dan dapat membantu menjaga kepadatan tulang, terutama pada wanita pasca-menopause. Memulai kebiasaan mengonsumsi produk olahan kedelai seperti susu atau suplemen adalah langkah cerdas untuk investasi kesehatan tulang jangka panjang.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artikel & Inspirasi"),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100],
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 650) {
            return buildListView(context);
          } else {
            return buildWrapLayout(context);
          }
        },
      ),
    );
  }

  // Widget untuk tampilan daftar di layar kecil (ponsel)
  Widget buildListView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        // Menambahkan Padding di bawah setiap kartu untuk memberi jarak
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: ArticleCard(article: article),
        );
      },
    );
  }

  // Widget untuk tampilan grid fleksibel di layar lebar
  Widget buildWrapLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Wrap(
          spacing: 24.0,
          runSpacing: 24.0,
          alignment: WrapAlignment.start,
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
}

// Kartu Artikel
class ArticleCard extends StatelessWidget {
  final Map<String, String> article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
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
      backgroundColor: Colors.grey[100], // Memberi warna latar belakang
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
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- PERUBAHAN DI SINI ---
                  // Properti height dan fit dihapus agar gambar tidak terpotong.
                  // Gambar akan ditampilkan utuh sesuai rasio aspek aslinya.
                  Image.asset(
                    article['image']!,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200, // Tinggi fallback jika gambar gagal dimuat
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
