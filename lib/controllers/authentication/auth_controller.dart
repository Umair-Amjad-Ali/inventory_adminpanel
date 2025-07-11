import 'dart:async';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoggedIn = false.obs;
  Timer? _logoutTimer;

  @override
  void onInit() {
    super.onInit();

    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _startAutoLogoutTimer();
        isLoggedIn.value = true;
      } else {
        isLoggedIn.value = false;
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        Get.snackbar("Login Error", "User ID is null.");
        return;
      }

      final adminDoc =
          await FirebaseFirestore.instance.collection('admins').doc(uid).get();

      if (adminDoc.exists && adminDoc['isAdmin'] == true) {
        _startAutoLogoutTimer();
        isLoggedIn.value = true;
        print("✅ Admin login successful");
      } else {
        await _auth.signOut();
        Get.snackbar("Access Denied", "You are not authorized as admin.");
      }
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }

  void _startAutoLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = Timer(const Duration(minutes: 60), () async {
      await _auth.signOut();
      Get.snackbar(
        "Session Expired",
        "You have been logged out due to inactivity.",
      );
    });
  }

  void logout() async {
    await _auth.signOut();
    _logoutTimer?.cancel();
    isLoggedIn.value = false;
    print("👋 Admin logged out");
  }
}
