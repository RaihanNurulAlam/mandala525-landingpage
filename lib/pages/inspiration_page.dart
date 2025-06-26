import 'package:flutter/material.dart';
import 'article_detail_page.dart';

class InspirationPage extends StatelessWidget {
  const InspirationPage({super.key});

  // Data artikel diperbarui dengan field 'content' untuk isi lengkap artikel.
  final List<Map<String, String>> articles = const [
    {
      'image': 'assets/images/testimoni.jpg',
      'title': 'Kisah Bapak Tirtayasa: Bangkit dari Nyeri Sendi Menahun',
      'summary':
          'Bertahun-tahun menderita nyeri sendi, Bapak Tirtayasa kini bisa kembali beraktivitas normal setelah rutin mengonsumsi New Mandala 525...',
      'content':
          'Bapak Tirtayasa, seorang pensiunan guru berusia 65 tahun, telah lama menderita nyeri sendi yang sangat mengganggu aktivitas hariannya. "Setiap mau sholat, sendi lutut saya sakit sekali," kenangnya. Setelah mencoba berbagai pengobatan, ia menemukan New Mandala 525. Dengan konsumsi rutin selama 3 bulan, perubahan signifikan ia rasakan. "Alhamdulillah, sekarang saya bisa berkebun lagi, bahkan menggendong cucu tanpa rasa sakit," ujarnya sambil tersenyum. Kisah beliau menjadi inspirasi bahwa usia bukanlah halangan untuk tetap aktif dan bebas dari nyeri sendi.',
    },
    {
      'image': 'assets/images/vitri.jpg',
      'title': 'Badan Bugar di Usia Senja, Rahasia Ibu Vitriani',
      'summary':
          'Siapa sangka di usianya yang sudah tidak muda lagi, Ibu Vitriani masih tampak bugar dan jarang sakit. Ternyata ini rahasianya...',
      'content':
          'Ibu Vitriani (70 tahun) sering membuat tetangganya kagum karena vitalitasnya. Saat yang lain sering mengeluh pegal linu, beliau masih aktif mengikuti senam setiap pagi. Rahasianya ternyata sederhana: pola hidup sehat dan asupan nutrisi yang tepat. "Selain makan sayur dan buah, saya rutin minum susu kedelai yang kaya akan kalsium dan isoflavon," ungkapnya. Menurutnya, nutrisi dari kedelai membantunya menjaga kepadatan tulang dan memberikan energi yang cukup untuk beraktivitas sepanjang hari. Beliau adalah bukti nyata bahwa menjaga kesehatan sejak dini adalah investasi terbaik untuk masa tua.',
    },
    // {
    //   'image': 'assets/images/inspiration3.jpg',
    //   'title': 'Pentingnya Menjaga Kesehatan Tulang Sejak Dini',
    //   'summary':
    //       'Osteoporosis bukanlah penyakit orang tua saja. Pelajari cara mencegahnya dan pentingnya nutrisi dari kedelai untuk tulang Anda.',
    //   'content':
    //       'Banyak yang mengira osteoporosis atau pengeroposan tulang hanya menyerang lansia. Faktanya, kesehatan tulang dibangun sejak masa muda. Kurangnya asupan kalsium dan vitamin D di usia produktif dapat mempercepat risiko osteoporosis di kemudian hari. Salah satu sumber nutrisi terbaik untuk tulang adalah kedelai. Kedelai mengandung isoflavon, senyawa yang strukturnya mirip estrogen dan dapat membantu menjaga kepadatan tulang, terutama pada wanita pasca-menopause. Memulai kebiasaan mengonsumsi produk olahan kedelai seperti susu atau suplemen adalah langkah cerdas untuk investasi kesehatan tulang jangka panjang.',
    // },
    // Anda bisa menambahkan lebih banyak artikel di sini
  ];

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder digunakan untuk mendapatkan constraints dari parent widget (dalam hal ini, layar)
    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika lebar layar lebih dari 800, gunakan GridView
        if (constraints.maxWidth > 800) {
          return buildGridView(context);
        } else {
          // Jika tidak, gunakan ListView yang menampilkan semua item
          return buildListView(context);
        }
      },
    );
  }

  // Widget untuk membangun tampilan ListView (untuk layar kecil)
  // Diperbarui untuk menampilkan semua artikel dan bisa di-scroll
  Widget buildListView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // --- PERUBAHAN DI SINI ---
      // itemCount dikembalikan untuk menampilkan semua artikel
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        // Menggunakan widget ArticleCard yang sudah dibuat
        return ArticleCard(article: article);
      },
    );
  }

  // Widget untuk membangun tampilan GridView (untuk layar lebar)
  Widget buildGridView(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      // Menentukan bagaimana item akan diatur dalam grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 24, // Spasi horizontal antar item
        mainAxisSpacing: 24, // Spasi vertikal antar item
        childAspectRatio: 0.85, // Rasio aspek item (lebar/tinggi) disesuaikan
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        // Menggunakan widget ArticleCard yang sama
        return ArticleCard(article: article);
      },
    );
  }
}

// --- WIDGET KARTU ARTIKEL YANG DAPAT DIGUNAKAN KEMBALI (DIPERBAIKI) ---
class ArticleCard extends StatelessWidget {
  final Map<String, String> article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gunakan placeholder jika gambar gagal dimuat
          Image.asset(
            article['image']!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              8,
            ), // Padding bawah dikurangi
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['title']!,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  article['summary']!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                // 'Spacer' diganti dengan SizedBox untuk memberi jarak yang pasti
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigasi ke halaman detail saat tombol ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ArticleDetailPage(article: article),
                        ),
                      );
                    },
                    child: const Text("Baca Selengkapnya ->"),
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
