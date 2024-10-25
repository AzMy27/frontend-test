// import 'dart:convert';
// import 'dart:io';

// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class ImagesController extends GetxController {
// //   File? _image;
//   XFile? _pickedFile;
//   XFile? get pickedFile => _pickedFile;
//   final _picker = ImagePicker();
//   Future<void> pickedImage() async {
//     _pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     update();
//     // if (_pickedFile != null) {
//     //   setState(() {
//     //     _image = File(_pickedFile!.path);
//     //   });
//     // }
//   }

//   Future<bool> upload() async {
//     bool success = false;
//     // http.StreamedResponse response = await updateProfile(_pickedFile);
//     http.StreamedResponse response = await updateProfile(_pickedFile);

//     if (response.statusCode == 200) {
//       Map map = jsonDecode(await response.stream.bytesToString());
//       String message = map['message'];
//       success = true;
//       print(message);
//       // _pickedFile = message;
//     } else {
//       print('Error uploading image');
//     }
//     update();
//     return success;
//   }

//   Future<http.StreamedResponse> updateProfile(XFile? data) async {
//     http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('http://192.168.0.9:3000/reports'));
//     // request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
//     if (GetPlatform.isMobile && data != null) {
//       File _file = File(data.path);
//       request.files.add(http.MultipartFile('images', _file.readAsBytes().asStream(), _file.lengthSync(),
//           filename: _file.path.split('/').last));
//     }
//     http.StreamedResponse response = await request.send();
//     return response;
//   }
// }
