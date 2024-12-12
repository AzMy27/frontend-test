// Buat file baru: widgets/image_with_token.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageWithToken extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const ImageWithToken({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Image.asset(
            'images/polbeng.png',
            width: width,
            height: height,
            fit: fit,
          );
        }

        return Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          headers: {
            'Authorization': 'Bearer ${snapshot.data}',
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'images/polbeng.png',
              width: width,
              height: height,
              fit: fit,
            );
          },
        );
      },
    );
  }
}
