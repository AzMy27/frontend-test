import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

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
            'Accept': 'application/json',
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            print('Image load error: $error');
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
