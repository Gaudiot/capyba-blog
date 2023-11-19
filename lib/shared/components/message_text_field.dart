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
        border: Border.all(width: 3, color: Colors.green),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 3,
          ),
          FloatingActionButton(
            onPressed: _submitMessage,
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}