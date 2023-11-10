// ignore: file_names
abstract class IFirebaseService{
  Future<void> configure();
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<dynamic> signUp();
  Future<dynamic> signIn();
}