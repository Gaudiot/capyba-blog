import 'package:firebase_auth/firebase_auth.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/models/entities/message.entity.dart';
import 'package:capyba_blog/models/errors/auth_exception_handler.dart';

abstract class IFirebaseService{
  Future<bool> isLoggedIn();
  Future<void> signOut();
  Future<AuthStatus> signUp(UserDTO user);
  Future<AuthStatus> signIn(UserDTO user);
  Future<User?> signInWithGoogle();
  Future<bool> sendValidationEmail();
  bool isUserVerified();
  User? getUser();

  Future<String?> uploadImage(String imagePath);
  Future<void> updateProfileImage(String imagePath);

  Future<List<MessageEntity>?> getMessages({required bool verifiedOnly});
  Future<dynamic> postMessage(String text);
  Future<dynamic> postRestrictMessage(String text);

  Future<AuthStatus> resetPassword({required String email});
}