import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            final docs = snapshot.data!.docs;
            final user = FirebaseAuth.instance.currentUser;
            return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: (ctx, index) => MessageBubble(
                message: docs[index]['text'],
                userName: docs[index]['username'],
                userImage: docs[index]['image_url'],
                isMe: docs[index]['userId'] == user!.uid ? true : false,
                key: ValueKey(docs[index].id),
              ),
            );
          }
        });
  }
}
