import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:android_fe/profil/crud/dai_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:android_fe/profil/edit_biodata.dart';

class ShowBiodata extends StatefulWidget {
  const ShowBiodata({super.key});

  @override
  State<ShowBiodata> createState() => _ShowBiodataState();
}

class _ShowBiodataState extends State<ShowBiodata> {
  void _showImageViewer(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.black,
          ),
          body: InteractiveViewer(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'images/bengkalis.png',
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Detail Biodata'.text.make().centered(),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditBiodataPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DaiProvider>(
        builder: (context, daiProvider, child) {
          if (daiProvider.isLoading) {
            return const CircularProgressIndicator().centered();
          }

          if (daiProvider.errorMessage == 'Unauthenticated') {
            return VStack([
              'Session Expired. Mohon Login Lagi'.text.make(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: 'Kembali ke Login'.text.make(),
              )
            ]).centered();
          }

          if (daiProvider.errorMessage != null) {
            return daiProvider.errorMessage!.text.make().centered();
          }

          final dai = daiProvider.daiProfile;
          if (dai == null) {
            return 'Data tidak tersedia'.text.make().centered();
          }

          return VStack([
            GestureDetector(
              onTap: () {
                if (dai.fotoDai != null) {
                  _showImageViewer(context, dai.fotoDai!);
                }
              },
              child: Container(
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
                              'images/bengkalis.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'images/bengkalis.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ).centered(),
            20.heightBox,
            _buildInfoCard(
              title: 'NIK',
              value: dai.nik.length > 4 ? '${dai.nik.substring(0, 4)}${'x' * (dai.nik.length - 4)}' : dai.nik,
              icon: Icons.badge,
            ),
            _buildInfoCard(title: 'Nama', value: dai.nama, icon: Icons.person),
            _buildInfoCard(title: 'No HP', value: dai.noHp, icon: Icons.phone),
            _buildInfoCard(title: 'Alamat', value: dai.alamat, icon: Icons.location_on),
            _buildInfoCard(title: 'RT', value: dai.rt, icon: Icons.location_on),
            _buildInfoCard(title: 'RW', value: dai.rw, icon: Icons.location_on),
            _buildInfoCard(title: 'Tempat Lahir', value: dai.tempatLahir, icon: Icons.location_city),
            _buildInfoCard(title: 'Tanggal Lahir', value: dai.tanggalLahir, icon: Icons.calendar_today),
            _buildInfoCard(title: 'Pendidikan Akhir', value: dai.pendidikanAkhir, icon: Icons.school),
            _buildInfoCard(title: 'Status Perkawinan', value: dai.statusKawin, icon: Icons.favorite),
          ])
              .scrollVertical()
              .box
              .width(context.screenWidth)
              .gradientFromTo(
                from: const Color(0xFFFFFFFF),
                to: const Color(0xFFD3D3D3),
              )
              .p16
              .make();
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return HStack([
      Icon(icon, color: Colors.blue),
      16.widthBox,
      VStack([
        title.text.gray500.sm.make(),
        4.heightBox,
        value.text.bold.size(16).make(),
      ], crossAlignment: CrossAxisAlignment.start)
          .expand(),
    ]).p16().box.margin(const EdgeInsets.symmetric(vertical: 8, horizontal: 16)).white.rounded.shadow.make();
  }
}
