import 'package:flutter/material.dart';

class InspirationPage extends StatelessWidget {
  const InspirationPage({super.key});

  final List<Map<String, String>> articles = const [
    {
      'image': 'assets/images/testimoni.jpg',
      'title': 'Kisah Bapak Tirtayasa: Bangkit dari Nyeri Sendi Menahun',
      'summary':
          'Bertahun-tahun menderita nyeri sendi, Bapak Tirtayasa kini bisa kembali beraktivitas normal setelah rutin mengonsumsi New Mandala 525...',
    },
    {
      'image': 'assets/images/vitri.jpg',
      'title': 'Badan Bugar di Usia Senja, Rahasia Ibu Vitriani',
      'summary':
          'Siapa sangka di usianya yang sudah tidak muda lagi, Ibu Vitriani masih tampak bugar dan jarang sakit. Ternyata ini rahasianya...',
    },
    {
      'image': 'assets/images/inspiration3.jpg',
      'title': 'Pentingnya Menjaga Kesehatan Tulang Sejak Dini',
      'summary':
          'Osteoporosis bukanlah penyakit orang tua saja. Pelajari cara mencegahnya dan pentingnya nutrisi dari kedelai untuk tulang Anda.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                article['image']!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title']!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article['summary']!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Halaman detail artikel akan segera hadir!',
                            ),
                          ),
                        );
                      },
                      child: const Text("Baca Selengkapnya ->"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
