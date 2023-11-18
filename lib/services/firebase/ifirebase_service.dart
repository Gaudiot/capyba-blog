import 'package:firebase_auth/firebase_auth.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';

abstract class IFirebaseService{
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<User?> signUp(UserDTO user);
  Future<User?> signIn(UserDTO user);
  Future<User?> signInWithGoogle();
  Future<bool> sendValidationEmail();
  bool isUserVerified();

  Future<dynamic> getMessages({required bool verifiedOnly});
}