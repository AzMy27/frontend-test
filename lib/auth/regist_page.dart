import 'package:android_fe/auth/app_logo.dart';
import 'package:android_fe/auth/login_page.dart';
import 'package:android_fe/routers.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0XFFF95A3B),
                  const Color(0XFFF96713),
                ],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomCenter,
                stops: [0.0, 0.8],
                tileMode: TileMode.mirror),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CommonLogo(),
                  HeightBox(10.0),
                  "Create Your Account".text.size(22).yellow100.make(),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Email",
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Masukkan Email" : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        errorStyle: TextStyle(color: Colors.white),
                        errorText: _isNotValidate ? "Masukkan Password" : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px24(),
                  HStack([
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RoutersPage()),
                        );
                      },
                      child: VxBox(
                        child: isLoading
                            ? CircularProgressIndicator() // Show loading spinner
                            : "Register".text.white.makeCentered().p16(),
                      ).green600.roundedLg.make().px16().py16(),
                    ),
                  ]),
                  GestureDetector(
                    onTap: () {
                      print('Sign In');
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: HStack(["Already Registered?".text.make(), " Sign In".text.white.make()]).centered(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
