import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar("Login Failed!", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.snackbar("Registration Successful!", "You can now log in!",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Registration Failed!", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
