import 'package:android_fe/profil/edit_biodata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_fe/profil/crud/dai_provider.dart';

class ShowBiodata extends StatefulWidget {
  const ShowBiodata({super.key});

  @override
  State<ShowBiodata> createState() => _ShowBiodataState();
}

class _ShowBiodataState extends State<ShowBiodata> {
  @override
  void initState() {
    super.initState();
    // Fetch data when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DaiProvider>(context, listen: false).fetchDaiProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Biodata'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BiodataPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DaiProvider>(
        builder: (context, daiProvider, child) {
          if (daiProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (daiProvider.errorMessage == 'Unauthenticated') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Session Expired. Mohon Login Lagi'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text('Kembali ke Login'),
                  )
                ],
              ),
            );
          }

          if (daiProvider.errorMessage != null) {
            return Center(child: Text(daiProvider.errorMessage!));
          }

          final dai = daiProvider.daiProfile;
          if (dai == null) {
            return const Center(child: Text('Data tidak tersedia'));
          }

          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFD3D3D3)],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomCenter,
                  stops: [0.0, 0.8],
                  tileMode: TileMode.mirror,
                ),
              ),
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: dai.fotoDai != null
                          ? Image.network(
                              dai.fotoDai!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'images/polbeng.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'images/polbeng.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInfoCard(
                    title: 'NIK',
                    value: dai.nik,
                    icon: Icons.badge,
                  ),
                  _buildInfoCard(
                    title: 'Nama',
                    value: dai.nama,
                    icon: Icons.person,
                  ),
                  _buildInfoCard(
                    title: 'No HP',
                    value: dai.noHp,
                    icon: Icons.phone,
                  ),
                  _buildInfoCard(
                    title: 'Alamat',
                    value: dai.alamat,
                    icon: Icons.location_on,
                  ),
                  _buildInfoCard(
                    title: 'Tempat Lahir',
                    value: dai.tempatLahir,
                    icon: Icons.location_city,
                  ),
                  _buildInfoCard(
                    title: 'Tanggal Lahir',
                    value: dai.tanggalLahir,
                    icon: Icons.calendar_today,
                  ),
                  _buildInfoCard(
                    title: 'Pendidikan Akhir',
                    value: dai.pendidikanAkhir,
                    icon: Icons.school,
                  ),
                  _buildInfoCard(
                    title: 'Status Perkawinan',
                    value: dai.statusKawin,
                    icon: Icons.favorite,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
