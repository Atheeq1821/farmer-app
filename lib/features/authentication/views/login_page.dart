import 'package:farmer_app/core/repeated/login_field.dart';
import 'package:farmer_app/core/themes/app_pallete.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.bgColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/elements/Ellipse26.png'
            )
            ),
            Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/elements/Ellipse25.png',
            ),
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
                  SizedBox(height: 15,),
                  Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontWeight: FontWeight.w700,
                      fontSize: 40,
                      color: Colors.white
                    ),
                    ),
                    LoginField(label: "User-code"),
                    SizedBox(height: 8,),
                    LoginField(label: "Password",isPass: true,),
                    SizedBox(height: 8,),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text("Forgot Password?"),
                    ),
                    Spacer(),  
                    Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: (){}, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.color2,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(12)
                          )
                        ),
                      
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white
                          ),
                          )
                        ),
                    )
                    
                ],
              ),
            )
        ],
      ),
    );
  }
}