import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('images/polbeng.png'),
        "Nama Aplikasi".text.xl2.italic.make(),
        "Slogan?".text.light.white.wider.lg.make(),
      ],
    );
  }
}
