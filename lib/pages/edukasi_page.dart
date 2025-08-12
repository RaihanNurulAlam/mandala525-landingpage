// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double horizontalPadding =
            constraints.maxWidth > 800 ? 64.0 : 20.0;

        return SingleChildScrollView(
          child: Center(
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
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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

                  BenefitItem(
                    icon: Icons.healing,
                    title: 'Membantu Penyembuhan & Mencegah Stroke',
                    description:
                        'Kandungan isoflavon dan antioksidan dalam kedelai dapat membantu memperbaiki pembuluh darah dan mengurangi peradangan. Ini berperan penting dalam proses pemulihan pasca-stroke sekaligus mengurangi faktor risiko terjadinya stroke berulang.',
                  ),
                  BenefitItem(
                    icon: Icons.security,
                    title: 'Menguatkan Tulang & Mencegah Osteoporosis',
                    description:
                        'Kedelai kaya akan isoflavon yang strukturnya mirip estrogen, membantu menjaga kepadatan mineral tulang. Konsumsi rutin sangat dianjurkan untuk wanita pasca-menopause guna mencegah pengeroposan tulang atau osteoporosis.',
                  ),
                  BenefitItem(
                    icon: Icons.favorite_border,
                    title: 'Meningkatkan Fungsi Jantung',
                    description:
                        'Lemak tak jenuh, serat, dan protein dalam kedelai efektif menurunkan kadar kolesterol jahat (LDL) dalam darah. Ini menjaga arteri tetap bersih dan elastis, sehingga mengurangi risiko penyakit jantung koroner.',
                  ),
                  BenefitItem(
                    icon: Icons.local_drink_outlined,
                    title: 'Manfaat Konsumsi Rutin',
                    description:
                        'Meminum susu kedelai secara teratur dapat meningkatkan kesehatan kulit karena kandungan antioksidannya, membantu menjaga berat badan ideal karena tinggi protein dan serat, serta memberikan energi yang stabil sepanjang hari.',
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
