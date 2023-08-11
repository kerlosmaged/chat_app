// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:chat_app/widgets/chat/message.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final userData = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: IconButton(
          onPressed: () {
            setState(() {
              FirebaseAuth.instance.signOut();
            });
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      body: const Column(
        children: [
          Expanded(
            child: Message(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
