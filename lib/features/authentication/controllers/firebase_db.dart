import 'package:farmer_app/features/authentication/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String?> login(String userCode, String password, WidgetRef ref) async {
  try {
    await ref
        .read(authControllerProvider)
        .loginWithUserCode(userCode, password);
    return "Success";
  } on FirebaseAuthException catch (e) {
    return e.message; 
  } catch (e) {
    return "User Code or password is invalid";
  }
}
