import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future signUp({required String email, required String password}) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  @override
  Future signIn({required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }
}