import 'package:firebase_auth/firebase_auth.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService implements IFirebaseService{
  @override
  Future<bool> isLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<User?> signUp(UserDTO user) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Sign${e.message}");
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signIn(UserDTO user) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email, 
        password: user.password
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<bool> sendValidationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      user!.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  bool isUserVerified() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user!.emailVerified;
    } catch (e) {
      return false;
    }
  }
}