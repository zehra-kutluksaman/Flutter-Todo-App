import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/view/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        _registerUser(name: name, email: email, password: password);
      }
    } catch (e) {
      Get.snackbar(
        'Başarılı',
        'Kayıt başarıyla yapıldı.',
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        icon: const Icon(Icons.add_task),
      );
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Get.to(const HomeScreen());
      }
    } catch (e) {
      Get.snackbar(
        'Başarısız',
        'Giriş  yapılamadı',
        colorText: Colors.black,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add_task),
      );
    }
  }

  Future<void> _registerUser(
      {required String name,
      required String email,
      required String password}) async {
    await userCollection
        .doc()
        .set({"email": email, "name": name, "password": password});
  }
}
