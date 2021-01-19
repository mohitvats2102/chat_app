import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMsg = '';
  final _controller = TextEditingController();

  void _sendMsg() async {
    //FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData=await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add({
      'text': _enteredMsg,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userimg':userData['user_img'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
      // color: Colors.pinkAccent,
      // ),

      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.all(2),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              maxLines: 2,
              keyboardType: TextInputType.multiline,
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMsg = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: _enteredMsg.trim().isEmpty ? null : _sendMsg,
          ),
        ],
      ),
    );
  }
}
