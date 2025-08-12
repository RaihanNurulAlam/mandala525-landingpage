// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DistributionPage extends StatefulWidget {
  const DistributionPage({super.key});

  @override
  _DistributionPageState createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk membuka WhatsApp
  void _launchWhatsApp(String phone) async {
    // Pastikan nomor diawali dengan 62 dan tanpa spasi/simbol
    final String formattedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    const String message =
        "Halo, saya tertarik dengan produk New Mandala 525. Apakah saya bisa mendapatkan informasi lebih lanjut?";
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Tidak dapat membuka WhatsApp. Pastikan aplikasi terinstal.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Latar belakang yang netral
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: const Text("Jaringan Distributor"),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                pinned: true,
                floating: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Cari nama, kota, atau provinsi...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: StreamBuilder<QuerySnapshot>(
            // Stream data dari Firestore
            stream:
                FirebaseFirestore.instance
                    .collection('distributors')
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Terjadi kesalahan. Coba lagi nanti."),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Belum ada distributor terdaftar."),
                );
              }

              // Filter data berdasarkan query pencarian
              final filteredDocs =
                  snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = (data['nama'] as String? ?? '').toLowerCase();
                    final city = (data['kota'] as String? ?? '').toLowerCase();
                    final province =
                        (data['provinsi'] as String? ?? '').toLowerCase();
                    return name.contains(_searchQuery) ||
                        city.contains(_searchQuery) ||
                        province.contains(_searchQuery);
                  }).toList();

              if (filteredDocs.isEmpty) {
                return const Center(
                  child: Text(
                    "Distributor tidak ditemukan.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  return DistributorCard(
                    data: data,
                    onWhatsAppTap:
                        () => _launchWhatsApp(data['whatsapp'] ?? ''),
                  );
                },
              );
            },
          ),
        ),
      ),
      // Tombol untuk mendaftar sebagai distributor
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRegistrationDialog(context),
        label: const Text("Gabung Jadi Distributor"),
        icon: const Icon(Icons.add_business_outlined),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Menampilkan modal untuk pendaftaran
  void _showRegistrationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const DistributorRegistrationForm();
      },
    );
  }
}

// Widget untuk setiap kartu distributor
class DistributorCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onWhatsAppTap;

  const DistributorCard({
    super.key,
    required this.data,
    required this.onWhatsAppTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['nama'] ?? 'Nama Distributor',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.location_on_outlined,
              text: data['alamat'] ?? 'Alamat tidak tersedia',
            ),
            const SizedBox(height: 8),
            InfoRow(
              icon: Icons.map_outlined,
              text: "${data['kota'] ?? ''}, ${data['provinsi'] ?? ''}",
            ),
            const Divider(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onWhatsAppTap,
                icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
                label: const Text("Pesan via WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget bantuan untuk baris info (ikon + teks)
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}

// Widget formulir pendaftaran yang stateful
class DistributorRegistrationForm extends StatefulWidget {
  const DistributorRegistrationForm({super.key});

  @override
  State<DistributorRegistrationForm> createState() =>
      _DistributorRegistrationFormState();
}

class _DistributorRegistrationFormState
    extends State<DistributorRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await FirebaseFirestore.instance
            .collection('distributor_applications')
            .add({
              'nama': _nameController.text,
              'whatsapp': _phoneController.text,
              'alamat': _addressController.text,
              'kota': _cityController.text,
              'provinsi': _provinceController.text,
              'status': 'pending',
              'timestamp': FieldValue.serverTimestamp(),
            });

        if (mounted) {
          Navigator.pop(context); // Tutup modal setelah berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Pendaftaran berhasil! Tim kami akan segera menghubungi Anda.",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print("Error submitting registration: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pendaftaran gagal. Mohon coba lagi."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bergabung Menjadi Distributor",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              const Text("Syarat & Ketentuan:"),
              const Text(
                "• Biaya Pendaftaran: Rp 500.000 (mendapatkan paket produk awal).\n"
                "• Bersedia mengikuti aturan dan harga jual yang ditetapkan.\n"
                "• Tim kami akan melakukan verifikasi setelah pendaftaran.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Divider(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap / Nama Toko",
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Nomor WhatsApp (Format: 628xxxx)",
                ),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.isEmpty
                            ? "Nomor WhatsApp tidak boleh kosong"
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Alamat Lengkap"),
                validator:
                    (value) =>
                        value!.isEmpty ? "Alamat tidak boleh kosong" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: "Kota"),
                      validator:
                          (value) =>
                              value!.isEmpty ? "Kota tidak boleh kosong" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _provinceController,
                      decoration: const InputDecoration(labelText: "Provinsi"),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? "Provinsi tidak boleh kosong"
                                  : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRegistration,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text("Daftar Sekarang"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
