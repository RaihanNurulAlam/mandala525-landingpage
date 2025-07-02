// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

// --- DATA MODEL ---
// Menggunakan kelas ini membuat kode lebih aman, bersih, dan mudah dikelola.
class Subdistributor {
  final String id;
  final String name;
  final String city;
  final String contact;
  final bool isVerified;

  Subdistributor({
    required this.id,
    required this.name,
    required this.city,
    required this.contact,
    required this.isVerified,
  });

  // Fungsi untuk mengubah data dari Firestore menjadi objek Subdistributor.
  factory Subdistributor.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Subdistributor(
      id: doc.id,
      name: data['name'] ?? '',
      city: data['city'] ?? '',
      contact: data['contact'] ?? '',
      // PENTING: Pastikan nama field di Firestore adalah 'isVerified' (camelCase).
      isVerified: data['isVerified'] ?? false,
    );
  }
}

// --- WIDGET UTAMA ---
class DistributionPage extends StatefulWidget {
  const DistributionPage({super.key});

  @override
  _DistributionPageState createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Subdistributor> _allAgents = [];
  List<Subdistributor> _filteredAgents = [];

  // Variabel untuk mengelola state UI.
  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _citySearchController = TextEditingController();
  final TextEditingController _agentSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAgents();
    _citySearchController.addListener(_filterAgents);
    _agentSearchController.addListener(_filterAgents);
  }

  @override
  void dispose() {
    _citySearchController.dispose();
    _agentSearchController.dispose();
    super.dispose();
  }

  /// Memuat daftar agen dari Firestore.
  Future<void> _loadAgents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final snapshot =
          await _firestore
              .collection('subdistributors')
              // Hanya tampilkan agen yang sudah terverifikasi oleh admin.
              .where('isVerified', isEqualTo: true)
              // Pengurutan ini memerlukan composite index di Firestore.
              .orderBy('city')
              .orderBy('name')
              .get();

      final agents =
          snapshot.docs
              .map((doc) => Subdistributor.fromFirestore(doc))
              .toList();

      setState(() {
        _allAgents = agents;
        _filteredAgents = agents;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Firestore Error: $e');
      setState(() {
        _errorMessage = 'Gagal memuat data agen.';
        _isLoading = false;
      });
    }
  }

  /// Menyaring daftar agen berdasarkan input dari search field.
  void _filterAgents() {
    final cityQuery = _citySearchController.text.toLowerCase();
    final agentQuery = _agentSearchController.text.toLowerCase();

    setState(() {
      _filteredAgents =
          _allAgents.where((agent) {
            final agentName = agent.name.toLowerCase();
            final agentCity = agent.city.toLowerCase();
            return agentName.contains(agentQuery) &&
                agentCity.contains(cityQuery);
          }).toList();
    });
  }

  /// Mendaftarkan calon subdistributor baru ke Firestore.
  Future<void> _registerSubdistributor({
    required String name,
    required String city,
    required String contact,
  }) async {
    try {
      await _firestore.collection('subdistributors').add({
        'name': name.trim(),
        'city': city.trim(),
        'contact': contact.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        // Calon baru selalu di-set false, perlu verifikasi dari admin.
        'isVerified': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran berhasil! Data Anda akan diverifikasi.'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message ?? 'Gagal mendaftar'}')),
      );
    }
  }

  /// Menampilkan dialog form pendaftaran.
  void _showRegistrationDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final cityController = TextEditingController();
    final contactController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // StatefulBuilder agar state loading hanya me-rebuild dialog, bukan seluruh halaman.
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Daftar Sebagai Subdistributor"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Nama Toko",
                        ),
                        validator:
                            (value) =>
                                value!.trim().isEmpty
                                    ? 'Nama toko wajib diisi'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: cityController,
                        decoration: const InputDecoration(labelText: "Kota"),
                        validator:
                            (value) =>
                                value!.trim().isEmpty
                                    ? 'Kota wajib diisi'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: contactController,
                        decoration: const InputDecoration(
                          labelText: "Nomor WhatsApp",
                        ),
                        keyboardType: TextInputType.phone,
                        validator:
                            (value) =>
                                value!.trim().isEmpty
                                    ? 'Nomor kontak wajib diisi'
                                    : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed:
                      isSubmitting
                          ? null
                          : () async {
                            if (formKey.currentState!.validate()) {
                              setDialogState(() => isSubmitting = true);
                              await _registerSubdistributor(
                                name: nameController.text,
                                city: cityController.text,
                                contact: contactController.text,
                              );
                              // Tidak perlu setDialogState lagi karena dialog akan ditutup
                              if (mounted) Navigator.pop(context);
                            }
                          },
                  child:
                      isSubmitting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Text("Daftar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body utama dibungkus dengan GestureDetector untuk menutup keyboard saat layar disentuh.
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _buildMainContent(),
      ),
    );
  }

  /// Membangun konten utama halaman.
  Widget _buildMainContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadAgents,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // RefreshIndicator memungkinkan pengguna menarik layar ke bawah untuk memuat ulang data.
    return RefreshIndicator(
      onRefresh: _loadAgents,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distribusi Resmi",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Temukan agen resmi di dekat kota Anda.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // --- KARTU PENDAFTARAN ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bergabung Menjadi Subdistributor",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Daftarkan toko Anda sekarang dan dapatkan keuntungannya:",
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("• Harga khusus distributor"),
                          Text("• Jaminan ketersediaan stok"),
                          Text("• Dukungan promosi"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showRegistrationDialog,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("DAFTAR SEKARANG"),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            // --- SEARCH FIELDS ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _citySearchController,
                    decoration: InputDecoration(
                      labelText: "Cari Kota",
                      prefixIcon: const Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _agentSearchController,
                    decoration: InputDecoration(
                      labelText: "Cari Agen",
                      prefixIcon: const Icon(Icons.person_search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- INFO HARGA ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Harga Agen Resmi: Rp 125.000 / box (Lebih Murah!)",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- DAFTAR AGEN ---
            Text(
              "Daftar Agen Resmi",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildAgentsList(),
          ],
        ),
      ),
    );
  }

  /// Membangun daftar agen atau pesan jika tidak ada.
  Widget _buildAgentsList() {
    if (_filteredAgents.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text("Agen tidak ditemukan"),
              Text(
                "Coba gunakan kata kunci lain",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredAgents.length,
      itemBuilder: (context, index) {
        final agent = _filteredAgents[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Text(
                // Mengambil huruf pertama dari kota.
                agent.city.isNotEmpty ? agent.city.substring(0, 1) : '?',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              agent.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(agent.city),
            trailing: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
              onPressed: () async {
                final url = Uri.parse('tel:${agent.contact}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tidak dapat melakukan panggilan ke ${agent.contact}',
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
