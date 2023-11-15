import 'package:firebase_auth/firebase_auth.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';

class FirebaseService implements IFirebaseService{
  @override
  Future<void> configure() async {
    
  }

  @override
  Future<bool> isLoggedIn() async {
    return true;
  }

  @override
  Future<void> logout() async {
  }

  @override
  Future<User?> signUp(UserDTO user) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future signIn({required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }
}