import 'package:android_fe/password/change_password.dart';
import 'package:android_fe/password/forgot_password_login.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Pengaturan'.text.make(),
      ),
      body: VStack([
        'Keamanan Akun'.text.bold.xl.make().p16().box.margin(const EdgeInsets.only(bottom: 8)).make(),
        ListTile(
          leading: const Icon(Icons.lock_outline),
          title: 'Ganti Password'.text.make(),
          subtitle: 'Ubah password anda'.text.sm.gray500.make(),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePassword(),
              ),
            );
          },
        ).box.border(color: Colors.grey.shade300).roundedSM.make().p8(),
        // ListTile(
        //   leading: const Icon(Icons.help_outline_sharp),
        //   title: 'Lupa Password'.text.make(),
        //   subtitle: 'Atur ulang password anda'.text.sm.gray500.make(),
        //   trailing: const Icon(Icons.arrow_forward_ios),
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => const ForgotPassword(),
        //       ),
        //     );
        //   },
        // ).box.border(color: Colors.grey.shade300).roundedSM.make().p8(),
        const Divider().py12(),
        'Lainnya'.text.bold.xl.make().p16().box.margin(const EdgeInsets.only(bottom: 8)).make(),
        ListTile(
          leading: const Icon(Icons.next_plan_outlined),
          title: 'Akan Datang'.text.make(),
          subtitle: 'Akan Datang'.text.sm.gray500.make(),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur ini akan segera hadir'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ).box.border(color: Colors.grey.shade300).roundedSM.make().p8(),
      ]).scrollVertical().p16(),
    );
  }
}
