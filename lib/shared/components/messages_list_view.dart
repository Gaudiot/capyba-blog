import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

import 'package:capyba_blog/models/entities/message.entity.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key, this.isRestricted = false});
  final bool isRestricted;

  @override
  Widget build(BuildContext context) {
    final messagesQuery = FirebaseFirestore.instance.collection('messages').where("verifiedOnly", isEqualTo: isRestricted)
      .orderBy('createdAt')
      .withConverter(
        fromFirestore: (snapshot, _) => MessageEntity.fromJson(snapshot.data()!),
        toFirestore: (message, options) => message.toJson()
    );
    
    return FirestoreListView<MessageEntity>(
      pageSize: 20,
      query: messagesQuery,
      loadingBuilder: (context) => const CircularProgressIndicator(),
      emptyBuilder: (context) {
        return const Text("No data");
      },
      itemBuilder: (context, doc) {
        final message = doc.data();
        return Text('Text is ${message.authorId}');
      },
      errorBuilder: (context, error, stackTrace) {
        return Text(error.toString());
      },
    );
  }
}