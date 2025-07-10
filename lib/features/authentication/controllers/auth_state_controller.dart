import 'package:farmer_app/features/authentication/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateController = StreamProvider<User?>((ref) {
  return ref.watch(authControllerProvider).authStateChanges;
});
