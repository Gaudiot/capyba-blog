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
  Future<void> logout() async{
  }

  @override
  Future signIn() async{
  }

  @override
  Future signUp() async{
  }
}