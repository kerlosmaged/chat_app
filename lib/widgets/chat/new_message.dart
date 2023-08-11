import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _textController = TextEditingController();
  String _enteredMessage = '';

  _sendMessage() async {
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': _enteredMessage,
        'createAt': Timestamp.now(),
        'username': userData['username'],
        'userId': user.uid,
        'image_url': userData['image_url'],
      },
    );

    _textController.clear();

    setState(() {
      _enteredMessage = ''; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              _enteredMessage.trim().isEmpty ? null : _sendMessage();
            },
            icon: Icon(
              Icons.send,
              color: _enteredMessage.trim().isEmpty ? Colors.grey : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
