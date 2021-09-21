import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/Helper/constants.dart';
import 'package:meet_up/services/database.dart';

class Conversation extends StatefulWidget {
  String chatRoomId = '';
  Conversation(this.chatRoomId);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream? chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            print(Constants.myName);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                          snapshot.data.docs[index].data()['message'],
                          snapshot.data.docs[index].data()['send'] ==
                              Constants.myName);
                    })
                : Container();
          } else {
            return Container();
          }
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "send": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = '';
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 75.0,
        backgroundColor: Colors.black,
        title: Center(
          child: Image(
            height: 150.0,
            fit: BoxFit.fitWidth,
            image: AssetImage('Images/Meetup.png'),
          ),
        ),
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey.shade900,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Message....',
                          hintStyle:
                              TextStyle(fontSize: 18.0, color: Colors.grey),
                          fillColor: Colors.grey.shade900,
                          filled: true,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 45.0,
                        width: 45.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: EdgeInsets.all(13.0),
                        child: Image.asset(
                          "Images/Message.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message, this.isSentByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.only(left: isSentByMe?0:24, right: isSentByMe?24: 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe
                ? [const Color(0xFF00796B), const Color(0xFF004D40)]
                : [const Color(0xFF303030), const Color(0xFF212121)],
          ),
          borderRadius: isSentByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17.0),
        ),
      ),
    );
  }
}
