import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/models/entities/message.entity.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/models/errors/auth_exception_handler.dart';

class FirebaseService implements IFirebaseService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> isLoggedIn() async {
    final user = _firebaseAuth.currentUser;
    return user != null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<AuthStatus> signUp(UserDTO user) async {
    AuthStatus authStatus;
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password
      );
      await _firebaseAuth.currentUser!.updateDisplayName(user.username);
      
      authStatus = AuthStatus.successful;
    } on FirebaseAuthException catch (err) {
      authStatus = AuthExceptionHandler.handleAuthException(err);
    }
    return authStatus;
  }

  @override
  Future<AuthStatus> signIn(UserDTO user) async {
    AuthStatus authStatus;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email, 
        password: user.password
      );
      
      authStatus = AuthStatus.successful;
    } on FirebaseAuthException catch (err) {
      authStatus = AuthExceptionHandler.handleAuthException(err);
    }
    return authStatus;
  }
  
  @override
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<bool> sendValidationEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      user!.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  bool isUserVerified() {
    try {
      final user = _firebaseAuth.currentUser;
      user!.reload();
      return user.emailVerified;
    } catch (e) {
      return false;
    }
  }

  @override
  User? getUser(){
    final user = _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<List<MessageEntity>?> getMessages({required bool verifiedOnly}) async{
    try {
      final snapshot = await _firebaseFirestore.collection("messages").where("verifiedOnly", isEqualTo: verifiedOnly).get();
      final messagesRaw = snapshot.docs;

      final messages = messagesRaw.map<MessageEntity>((messageRaw){
        final message = MessageEntity.fromJson(messageRaw.data());
        message.setMessageId(messageRaw.id);

        return message;
      }).toList();
      return messages;
    } on FirebaseException catch (_) {
      return null;
    }
  }
  
  @override
  Future postMessage(String text) async {
    final user = _firebaseAuth.currentUser;
    if(user == null) return null;
    
    final now = DateTime.now();
    final MessageEntity message = MessageEntity(
      authorId: user.uid, 
      authorUsername: user.displayName ?? "", 
      text: text, 
      verifiedOnly: false, 
      createdAt: now, 
      updatedAt: now
    );

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection("messages").add(message.toJson());
  }
  
  @override
  Future postRestrictMessage(String text) async {
    final user = _firebaseAuth.currentUser;
    if(user == null) return null;
    
    final now = DateTime.now();
    final MessageEntity message = MessageEntity(
      authorId: user.uid, 
      authorUsername: user.displayName ?? "", 
      text: text, 
      verifiedOnly: true, 
      createdAt: now, 
      updatedAt: now
    );

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection("messages").add(message.toJson());
  }

  @override
  Future<String?> uploadImage(String imagePath) async{
    try {
      final File imageFile = File(imagePath);
      final String path = 'profileImages/${imageFile.hashCode}';

      final ref = _firebaseStorage.ref().child(path);
      final taskSnapshot = await ref.putFile(imageFile).whenComplete((){});
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateProfileImage(String imagePath) async{
    final downloadUrl = await uploadImage(imagePath);
    await _firebaseAuth.currentUser!.updatePhotoURL(downloadUrl);
  }

  @override
  Future<AuthStatus> resetPassword({required String email}) async{
    AuthStatus authStatus;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      authStatus = AuthStatus.successful;
    } on FirebaseAuthException catch (err) {
      authStatus = AuthExceptionHandler.handleAuthException(err);
    }
    return authStatus;
  }
}