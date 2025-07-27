import 'package:farmer_app/features/authentication/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmer_app/features/navigation/views/main_screen.dart';


class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  Future<Widget> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? loginTime = prefs.getString('loginTime');

    if (isLoggedIn && loginTime != null) {
      final loginDate = DateTime.parse(loginTime);
      final now = DateTime.now();
      if (now.difference(loginDate).inDays <= 7) {
        return MainScreen(); // Session valid
      } else {
        await prefs.clear(); // Session expired
      }
    }
    return LoginPage(); // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data!;
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
