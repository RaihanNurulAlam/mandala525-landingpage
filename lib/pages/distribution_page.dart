import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DistributionPage extends StatefulWidget {
  const DistributionPage({super.key});

  @override
  _DistributionPageState createState() => _DistributionPageState();
}

class _DistributionPageState extends State<DistributionPage> {
  final List<Map<String, String>> allAgents = [
    {
      'name': 'Sehat Selalu Store',
      'city': 'Jakarta',
      'contact': '081234567890',
    },
    {
      'name': 'Warung Herbal Lestari',
      'city': 'Jakarta',
      'contact': '081234567891',
    },
    {
      'name': 'Agen Mandala Bandung',
      'city': 'Bandung',
      'contact': '082345678901',
    },
    {
      'name': 'Toko Barokah Jaya',
      'city': 'Surabaya',
      'contact': '083456789012',
    },
    {
      'name': 'Sumber Waras Jogja',
      'city': 'Yogyakarta',
      'contact': '084567890123',
    },
    {
      'name': 'Agen Mandala Sejahtera',
      'city': 'Bandung',
      'contact': '085678901234',
    },
    {
      'name': 'Herbalindo Surabaya',
      'city': 'Surabaya',
      'contact': '086789012345',
    },
  ];

  List<Map<String, String>> filteredAgents = [];
  final TextEditingController cityController = TextEditingController();
  final TextEditingController agentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredAgents = allAgents;
    cityController.addListener(_filterAgents);
    agentController.addListener(_filterAgents);
  }

  void _filterAgents() {
    String cityQuery = cityController.text.toLowerCase();
    String agentQuery = agentController.text.toLowerCase();

    setState(() {
      filteredAgents =
          allAgents.where((agent) {
            final agentName = agent['name']!.toLowerCase();
            final agentCity = agent['city']!.toLowerCase();
            return agentName.contains(agentQuery) &&
                agentCity.contains(cityQuery);
          }).toList();
    });
  }

  @override
  void dispose() {
    cityController.dispose();
    agentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distribusi Resmi",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Temukan agen resmi terdekat di kota Anda dan dapatkan harga spesial.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: "Cari Kota",
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: agentController,
                    decoration: const InputDecoration(
                      labelText: "Cari Nama Agen",
                      prefixIcon: Icon(Icons.person_search),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
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
                      "Harga Agen Resmi: Rp 125.000 / box (Lebih murah!)",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text("Daftar Agen", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            filteredAgents.isEmpty
                ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("Agen tidak ditemukan."),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredAgents.length,
                  itemBuilder: (context, index) {
                    final agent = filteredAgents[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(agent['city']![0])),
                        title: Text(agent['name']!),
                        subtitle: Text(agent['city']!),
                        trailing: IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () async {
                            final url = 'tel:${agent['contact']}';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
