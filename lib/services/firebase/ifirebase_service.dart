// ignore: file_names
abstract class IFirebaseService{
  Future<void> configure();
  Future<bool> isLoggedIn();
  Future<void> logout();
  Future<dynamic> signUp({required String email, required String password});
  Future<dynamic> signIn({required String email, required String password});
}