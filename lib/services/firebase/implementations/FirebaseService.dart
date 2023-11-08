import 'package:capyba_blog/services/firebase/IFirebaseService.dart';

class FirebaseService implements IFirebaseService{
  @override
  Future<bool> isLoggedIn() async {
    return true;
  }

  @override
  Future<void> logout() async{
  }

  @override
  Future signIn() async{
  }

  @override
  Future signUp() async{
  }
}