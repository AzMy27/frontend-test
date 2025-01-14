import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Tentang".text.make(),
      ),
      body: VStack([
        Image.asset(
          'images/bengkalis-bermasa.png',
          width: 120,
          height: 120,
        ).box.roundedFull.border(color: Colors.blue, width: 2).clip(Clip.antiAlias).make().centered(),
        20.heightBox,
        "Dai Bermasa".text.blue500.size(24).bold.make().centered(),
        "Versi 1.0.0".text.gray500.size(16).make().centered(),
        30.heightBox,
        "Tentang Aplikasi".text.bold.size(20).make().centered(),
        10.heightBox,
        "Aplikasi ini adalah aplikasi untuk mengelola dan memantau aktivitas para Dai dalam melakukan dakwah di masyarakat. Aplikasi ini membantu mengorganisir kegiatan dakwah dengan lebih efektif dan terstruktur."
            .text
            .center
            .size(16)
            .make()
            .p16(),
        30.heightBox,
        "Pengembang".text.bold.size(20).make().centered(),
        20.heightBox,
        VStack([
          "Muhammad Azmi".text.bold.size(18).make().centered(),
          "Pengembang Aplikasi".text.blue500.size(16).make().centered(),
          "Mahasiswa Politeknik Negeri Bengkalis".text.gray500.size(14).make().centered(),
        ]).p16().box.roundedLg.color(Colors.blue.withOpacity(0.1)).make().w(context.screenWidth * 0.85).centered(),
        15.heightBox,
        VStack([
          "Elvi Rahmi, S.T., M.Kom".text.bold.size(18).make().centered(),
          "Dosen Pembimbing".text.blue500.size(16).make().centered(),
          "Dosen Politeknik Negeri Bengkalis".text.gray500.size(14).make().centered(),
        ]).p16().box.roundedLg.color(Colors.blue.withOpacity(0.1)).make().w(context.screenWidth * 0.85).centered(),
        30.heightBox,
        // "© 2024 Muhammad Azmi\n Semua hak cipta dilindungi".text.gray500.size(14).center.make().centered(),
        20.heightBox,
      ]).scrollVertical().p20(),
    );
  }
}
