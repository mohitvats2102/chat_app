import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  final String msg;
  final bool isMe;
  final Key key;
  // final String userId;
  final String username;
  final String imgUrl;
  MessageBubble(
    this.msg,
    this.isMe,
    this.username,
    this.imgUrl, {
    this.key,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 6,
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: isMe ? Radius.circular(15) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(15),
                ),
                color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(2, -5),
                //   )
                // ],
              ),
              width: 180,
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  // FutureBuilder(
                  //   future: Firestore.instance.collection('users').document(userId).get(),
                  //   builder: (ctx,snapShot){
                  //     if(snapShot.connectionState==ConnectionState.waiting){
                  //       return Text('Loading..');
                  //     }
                  //     return
                  Text(
                    username,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.headline1.color,
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
                  ),
                  //    },
                  // ),

                  Text(
                    msg,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context).accentTextTheme.headline1.color,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: !isMe?158:null,
          right: isMe?158:null,
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              imgUrl,
            ),
          ),
        )
      ],
      overflow: Overflow.visible,
    );
  }
}
