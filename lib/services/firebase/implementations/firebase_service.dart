import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:capyba_blog/models/DTOs/user.dto.dart';
import 'package:capyba_blog/models/entities/message.entity.dart';
import 'package:capyba_blog/services/firebase/ifirebase_service.dart';

class FirebaseService implements IFirebaseService{
  @override
  Future<bool> isLoggedIn() async {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<User?> signUp(UserDTO user) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password
      );
      final userInfo = userCredential.user!;
      userInfo.updateDisplayName(user.username);
      return userInfo;
    } on FirebaseAuthException catch (e) {
      debugPrint("Sign${e.message}");
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signIn(UserDTO user) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email, 
        password: user.password
      );
      return userCredential.user;
    } catch (e) {
      return null;
    }
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

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<bool> sendValidationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      user!.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }
  
  @override
  bool isUserVerified() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      return user!.emailVerified;
    } catch (e) {
      return false;
    }
  }

  @override
  User? getUser(){
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  @override
  Future<List<MessageEntity>?> getMessages({required bool verifiedOnly}) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final snapshot = await firebaseFirestore.collection("messages").where("verifiedOnly", isEqualTo: verifiedOnly).get();
    final messagesRaw = snapshot.docs;

    final messages = messagesRaw.map<MessageEntity>((messageRaw){
      final message = MessageEntity.fromJson(messageRaw.data());
      message.setMessageId(messageRaw.id);

      return message;
    }).toList();
    return messages;
  }
  
  @override
  Future postMessage(String text) async {
    final user = FirebaseAuth.instance.currentUser;
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
    final user = FirebaseAuth.instance.currentUser;
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
}