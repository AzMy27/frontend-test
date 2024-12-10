import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('images/bengkalis-bermasa.png').pOnly(bottom: 10),
        // "Aplikasi Dai Bermasa".text.xl2.orange700.italic.make(),
        // "Slogan?".text.light.white.wider.lg.make(),
      ],
    );
  }
}
