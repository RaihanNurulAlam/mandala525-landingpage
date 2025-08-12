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

  List<DocumentSnapshot> _allDistributors = [];
  List<DocumentSnapshot> _filteredDistributors = [];

  List<String> _uniqueProvinces = [];
  List<String> _uniqueCities = [];
  String? _selectedProvince;
  String? _selectedCity;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAllDistributors();
    _searchController.addListener(_filterDistributors);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterDistributors);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllDistributors() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final approvedSnapshot =
          await FirebaseFirestore.instance.collection('distributors').get();
      final applicationSnapshot =
          await FirebaseFirestore.instance
              .collection('distributor_applications')
              .get();

      final allDocs = <String, DocumentSnapshot>{};

      for (var doc in applicationSnapshot.docs) {
        final data = doc.data();
        final whatsapp = data['whatsapp'] as String?;
        if (whatsapp != null && whatsapp.isNotEmpty) allDocs[whatsapp] = doc;
      }
      for (var doc in approvedSnapshot.docs) {
        final data = doc.data();
        final whatsapp = data['whatsapp'] as String?;
        if (whatsapp != null && whatsapp.isNotEmpty) allDocs[whatsapp] = doc;
      }

      _allDistributors = allDocs.values.toList();
      _allDistributors.sort((a, b) {
        final nameA =
            (a.data() as Map<String, dynamic>)['nama'] as String? ?? '';
        final nameB =
            (b.data() as Map<String, dynamic>)['nama'] as String? ?? '';
        return nameA.compareTo(nameB);
      });

      _populateFilters();
      _filterDistributors();
    } catch (e) {
      print("Error loading distributors: $e");
      setState(() {
        _errorMessage = "Gagal memuat data. Periksa koneksi internet Anda.";
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _populateFilters() {
    final provinces = <String>{};
    for (var doc in _allDistributors) {
      final data = doc.data() as Map<String, dynamic>;
      final province = data['provinsi'] as String?;
      if (province != null && province.isNotEmpty) provinces.add(province);
    }
    _uniqueProvinces = provinces.toList()..sort();
  }

  void _updateCityFilter() {
    final cities = <String>{};
    if (_selectedProvince != null) {
      for (var doc in _allDistributors) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['provinsi'] == _selectedProvince) {
          final city = data['kota'] as String?;
          if (city != null && city.isNotEmpty) cities.add(city);
        }
      }
    }
    _uniqueCities = cities.toList()..sort();
    if (!_uniqueCities.contains(_selectedCity)) {
      _selectedCity = null;
    }
  }

  void _filterDistributors() {
    List<DocumentSnapshot> results = List.from(_allDistributors);

    if (_selectedProvince != null) {
      results =
          results.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['provinsi'] == _selectedProvince;
          }).toList();
    }

    if (_selectedCity != null) {
      results =
          results.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['kota'] == _selectedCity;
          }).toList();
    }

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      results =
          results.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final name = (data['nama'] as String? ?? '').toLowerCase();
            final city = (data['kota'] as String? ?? '').toLowerCase();
            final province = (data['provinsi'] as String? ?? '').toLowerCase();
            return name.contains(query) ||
                city.contains(query) ||
                province.contains(query);
          }).toList();
    }

    setState(() => _filteredDistributors = results);
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
      }
    }
  }

  void _launchWhatsApp(String phone) async {
    final String formattedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    const String message =
        "Halo, saya tertarik dengan produk New Mandala 525...";
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tidak dapat membuka WhatsApp."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(""),
        elevation: 0,
        backgroundColor: Colors.grey[50],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: RefreshIndicator(
            onRefresh: _loadAllDistributors,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        child: Text(
                          "Jaringan Distributor",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildFilterSection()),
                    _buildDistributorSliverContent(constraints),
                    SliverToBoxAdapter(
                      child: _buildMarketplaceSection(context),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRegistrationModal(context),
        label: const Text("Gabung Jadi Distributor"),
        icon: const Icon(Icons.add_business_outlined),
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Cari nama, kota, atau provinsi...",
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  hint: "Pilih Provinsi",
                  value: _selectedProvince,
                  items: _uniqueProvinces,
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                      _selectedCity = null;
                      _updateCityFilter();
                    });
                    _filterDistributors();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  hint: "Pilih Kota",
                  value: _selectedCity,
                  items: _uniqueCities,
                  onChanged:
                      _selectedProvince == null
                          ? null
                          : (value) {
                            setState(() => _selectedCity = value);
                            _filterDistributors();
                          },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      isExpanded: true,
      items:
          items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildDistributorSliverContent(BoxConstraints constraints) {
    if (_isLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return SliverFillRemaining(child: Center(child: Text(_errorMessage!)));
    }
    if (_filteredDistributors.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.0),
          child: Center(
            child: Text(
              "Distributor tidak ditemukan.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    // --- [FIX] Mengganti layout desktop menjadi Wrap dengan lebar card yang tetap ---
    if (constraints.maxWidth > 600) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverToBoxAdapter(
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            alignment: WrapAlignment.center, // Pusatkan kartu-kartu
            children:
                _filteredDistributors.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  // Beri lebar tetap pada kartu agar responsif secara alami
                  return SizedBox(
                    width: 350,
                    child: DistributorCard(
                      data: data,
                      onWhatsAppTap:
                          () => _launchWhatsApp(data['whatsapp'] ?? ''),
                    ),
                  );
                }).toList(),
          ),
        ),
      );
    } else {
      // Tampilan mobile tetap menggunakan SliverList
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final data =
                _filteredDistributors[index].data() as Map<String, dynamic>;
            return DistributorCard(
              data: data,
              onWhatsAppTap: () => _launchWhatsApp(data['whatsapp'] ?? ''),
            );
          }, childCount: _filteredDistributors.length),
        ),
      );
    }
  }

  Widget _buildMarketplaceSection(BuildContext context) {
    final List<Map<String, String>> marketplaces = [
      {'image': 'assets/images/img-shopee.jpg', 'url': 'https://shopee.co.id'},
      {
        'image': 'assets/images/img-tokopedia.jpg',
        'url': 'https://www.tokopedia.com',
      },
      {
        'image': 'assets/images/img-lazada.jpg',
        'url': 'https://www.lazada.co.id',
      },
    ];

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Text(
            "Belanja Susu New Mandala 525",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Dapatkan susu New Mandala 525 di berbagai marketplace kesayangan anda",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24.0,
            runSpacing: 24.0,
            alignment: WrapAlignment.center,
            children:
                marketplaces.map((item) {
                  return InkWell(
                    onTap: () => _launchURL(item['url']!),
                    child: Image.asset(
                      item['image']!,
                      height: 60,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            height: 60,
                            width: 120,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: Text(
                                item['image']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  void _showRegistrationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return DistributorRegistrationForm(
              scrollController: scrollController,
              onSuccess: _loadAllDistributors,
            );
          },
        );
      },
    );
  }
}

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
    final bool isApplication = data['status'] == 'pending';
    final Color chipColor =
        isApplication ? Colors.amber.shade700 : Colors.green.shade700;
    final String chipLabel = isApplication ? 'Pendaftar' : 'Agen Resmi';

    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['nama'] ?? 'Nama Distributor',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    chipLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  backgroundColor: chipColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  labelPadding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.location_on_outlined,
              text: "${data['kota'] ?? ''}, ${data['provinsi'] ?? ''}",
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color.fromARGB(255, 230, 230, 230)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InfoRow(
                    icon: FontAwesomeIcons.whatsapp,
                    text: data['whatsapp'] ?? 'Nomor tidak ada',
                    isBold: true,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onWhatsAppTap,
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text("Chat"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade700,
                    elevation: 1,
                    shadowColor: Colors.black.withOpacity(0.1),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isBold;
  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class DistributorRegistrationForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final ScrollController scrollController;
  const DistributorRegistrationForm({
    super.key,
    required this.onSuccess,
    required this.scrollController,
  });

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
    FocusScope.of(context).unfocus();

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
          Navigator.pop(context);
          widget.onSuccess();
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pendaftaran gagal. Silakan coba lagi."),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              children: [
                _buildSectionTitle("Keuntungan Menjadi Distributor"),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: Text("Harga Khusus Distributor"),
                  subtitle: Text("Dapatkan margin keuntungan yang menarik."),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: Text("Dukungan Pemasaran"),
                  subtitle: Text(
                    "Materi promosi eksklusif untuk membantu penjualan Anda.",
                  ),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: Text("Prioritas Stok Produk"),
                  subtitle: Text(
                    "Jadilah yang pertama mendapatkan produk terbaru.",
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildSectionTitle("Syarat & Ketentuan"),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Text("1."),
                  title: Text("Komitmen Pembelian Awal"),
                  subtitle: Text(
                    "Diperlukan pembelian minimum pada pendaftaran pertama.",
                  ),
                ),
                const ListTile(
                  leading: Text("2."),
                  title: Text("Memiliki Lokasi Usaha"),
                  subtitle: Text("Memiliki toko fisik atau online yang aktif."),
                ),
                const ListTile(
                  leading: Text("3."),
                  title: Text("Menjaga Nama Baik Brand"),
                  subtitle: Text(
                    "Berkomitmen untuk tidak merusak citra produk.",
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildSectionTitle("Formulir Pendaftaran"),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        controller: _nameController,
                        labelText: "Nama Lengkap / Toko",
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _phoneController,
                        labelText: "Nomor WhatsApp (cth: 62812...)",
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      _buildTextFormField(
                        controller: _addressController,
                        labelText: "Alamat Lengkap",
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              controller: _cityController,
                              labelText: "Kota",
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _provinceController,
                              labelText: "Provinsi",
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
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: keyboardType,
      validator: (v) => v == null || v.isEmpty ? "Kolom ini wajib diisi" : null,
    );
  }
}
