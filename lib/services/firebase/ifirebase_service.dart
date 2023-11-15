import 'package:firebase_auth/firebase_auth.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';

abstract class IFirebaseService{
  Future<void> configure();
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<User?> signUp(UserDTO user);
  Future<dynamic> signIn({required String email, required String password});
}