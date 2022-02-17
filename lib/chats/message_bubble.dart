import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.documenttype,this.message, this.name, this.imageUrl, this.isMe, 
      {this.key});

  final Key key;
  final String message;
  final bool isMe;
  final String name;
  final String imageUrl;
  final String documenttype;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            documenttype=='image'?Container(
              padding: EdgeInsets.all(10),
              child: Image.network(message,width: 150,height: 180,fit:BoxFit.fill  
)):
            Container(
              decoration: BoxDecoration(
                  //set different color of different user
                  color:
                      isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft:
                        !isMe ? Radius.circular(0) : Radius.circular(12),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 170,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  // FutureBuilder(
                  //     future: Firestore.instance
                  //         .collection('users')
                  //         .document(userId)
                  //         .get(),
                  //     builder: (context, snapshot) {
                  //       //Snapshot hold the data about the user
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return Text('Loading..');
                  //       }
                  //       return
                  Text(
                    //fetch the username with the userId gorgeous thing!
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1.color,
                    ),
                  ),

                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1
                                .color),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        //User Image
        documenttype=='image'?
        Positioned(
            top: 0,
            left: isMe? null: 140,
            right: isMe? 140: null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl==null?'https://cdn2.iconfinder.com/data/icons/facebook-51/32/FACEBOOK_LINE-01-512.png':imageUrl),
            ))
        :Positioned(
            top: 0,
            left: isMe? null: 150,
            right: isMe? 150: null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl==null?'https://cdn2.iconfinder.com/data/icons/facebook-51/32/FACEBOOK_LINE-01-512.png':imageUrl),
            )),
      ],
      //to show the overflow widget as the top is set negative value
      overflow: Overflow.visible,
    );
  }
}
