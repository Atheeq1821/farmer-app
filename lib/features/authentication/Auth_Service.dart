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
