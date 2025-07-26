import 'package:farmer_app/core/repeated/login_field.dart';
import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:farmer_app/features/navigation/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/views/home-page.dart';
import '../Auth_Service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // important
      backgroundColor: AppPallete.bgColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/elements/Background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset('assets/elements/Ellipse26.png'),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('assets/elements/Ellipse25.png'),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 60,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/logo_svastha.png',
                              width: 298,
                              height: 298,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        ),
                        LoginField(label: "User-code", controller: userController),
                        SizedBox(height: 8),
                        LoginField(
                          label: "Password",
                          controller: passwordController,
                          isPass: true,
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text("Forgot Password?"),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              String? result = await login(
                                userController.text,
                                passwordController.text,
                                ref,
                              );
                              if (result == "Success") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Logged in successfully")),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => MainScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result ?? "Login Failed")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.color2,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
