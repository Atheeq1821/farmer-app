import 'package:farmer_app/features/authentication/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<String?> login(
  String userCode,
  String password,
  WidgetRef ref,
) async {
  try {
    await ref.read(authControllerProvider).loginWithUserCode(userCode, password);
    return "Success";
  } catch (e) {
    return null;
  }
}
