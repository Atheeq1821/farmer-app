import 'package:farmer_app/core/repeated/login_field.dart';
import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:farmer_app/features/authentication/controllers/firebase_db.dart';
import 'package:farmer_app/features/navigation/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      backgroundColor: AppPallete.bgColor,
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.all(30.0),
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
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.color2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),
                      ),
                    ),

                    child: GestureDetector(
                      onTap: () {
                        Future<String?> result = login(
                          userController.text,
                          passwordController.text,
                          ref,
                        );
                        if (result == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Login failed: Usercode doesnt match",
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("LoggedIn Successfully")),
                          );
                          Navigator.pushReplacement(
                            context, 
                            MaterialPageRoute(builder: (_) => const MainScreen())
                          );
                        }
                      },
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
