import 'package:farmer_app/features/authentication/views/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String?> login(String email, String password, WidgetRef ref) async {
  final supabase = Supabase.instance.client;

  try {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (res.user != null) {
      return "Success";
    } else {
      return "Invalid credentials";
    }
  } catch (e) {
    return e.toString();
  }
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => LoginPage()),
  );
}
