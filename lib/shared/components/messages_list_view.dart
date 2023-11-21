import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
        return const _NoMessages();
      },
      itemBuilder: (context, doc) {
        final message = doc.data();
        return _MessageCard(message);
      },
      errorBuilder: (context, error, stackTrace) {
        return const _ErrorMessage();
      },
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard(this.message, {super.key});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message.authorUsername, style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 15
              )),
              Text(DateFormat('dd/MM/yyyy HH:mm').format(message.createdAt))
            ],
          ),
          Text(message.text),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
          )
        ],
      ),
    );
  }
}

class _NoMessages extends StatelessWidget {
  const _NoMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(FontAwesomeIcons.commentSlash, size: 150, color: Color(0xFF00E963)),
          Text("No messages yet. Be the first!", style: TextStyle(
            fontSize: 20
          ))
        ],
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(FontAwesomeIcons.circleExclamation, size: 150, color: Colors.red),
          Text("An error ocurred while trying to fetch the messages. Please try again later.", 
            style: TextStyle(
              fontSize: 20,
            ), 
            textAlign: TextAlign.center
          )
        ],
      ),
    );
  }
}