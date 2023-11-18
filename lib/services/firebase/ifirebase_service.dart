import 'package:firebase_auth/firebase_auth.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/models/entities/message.entity.dart';

abstract class IFirebaseService{
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<User?> signUp(UserDTO user);
  Future<User?> signIn(UserDTO user);
  Future<User?> signInWithGoogle();
  Future<bool> sendValidationEmail();
  bool isUserVerified();

  Future<List<MessageEntity>?> getMessages({required bool verifiedOnly});
  Future<dynamic> postMessage(String text);
  Future<dynamic> postRestrictMessage(String text);
}