import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy(
                'createdAt',
                descending: true,
              )
              .snapshots(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final chatsDocs = snapShot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: chatsDocs.length,
              itemBuilder: (ctx, i) {
                return MessageBubble(
                  chatsDocs[i]['text'],
                  futureSnapshot.data.uid == chatsDocs[i]['userId'],
                  chatsDocs[i]['username'],
                  chatsDocs[i]['userimg'],
                  key: ValueKey(chatsDocs[i].documentID),
                );
              },
            );
          },
        );
      },
    );
  }
}
