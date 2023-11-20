import 'package:flutter/material.dart';

import 'package:capyba_blog/services/firebase/ifirebase_service.dart';
import 'package:capyba_blog/services/firebase/implementations/firebase_service.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({super.key, this.isRestricted = false});
  final bool isRestricted;

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final IFirebaseService firebaseService = FirebaseService();

  final _controller = TextEditingController();

  Future<void> _submitMessage() async{
    final textMessage = _controller.text.trim();
    _controller.clear();

    if(textMessage.isEmpty) return;

    if(widget.isRestricted){
      await firebaseService.postRestrictMessage(textMessage);
    }else{
      await firebaseService.postMessage(textMessage);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDEDEDE),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _controller,
              maxLines: null,
              minLines: 3,
              decoration: const InputDecoration.collapsed(
                hintText: "Share your thoughts...",
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 15)
              ),
              onPressed: _submitMessage,
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}