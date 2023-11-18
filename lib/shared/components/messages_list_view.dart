import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:intl/intl.dart';

import 'package:capyba_blog/models/entities/message.entity.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key, this.isRestricted = false});
  final bool isRestricted;

  @override
  Widget build(BuildContext context) {
    final messagesQuery = FirebaseFirestore.instance.collection('messages').where("verifiedOnly", isEqualTo: isRestricted)
      .orderBy('createdAt', descending: true)
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
        return _MessageCard(message);
      },
      errorBuilder: (context, error, stackTrace) {
        return Text(error.toString());
      },
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard(this.message, {super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message.authorUsername),
              Text(DateFormat('dd/MM/yyyy').format(message.createdAt))
            ],
          ),
          Text(message.text)
        ],
      )
    );
  }
}