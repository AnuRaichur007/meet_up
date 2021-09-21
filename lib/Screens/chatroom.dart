import 'package:flutter/material.dart';
import 'package:meet_up/Helper/authenticate.dart';
import 'package:meet_up/Helper/constants.dart';
import 'package:meet_up/Helper/helperFunction.dart';
import 'package:meet_up/Screens/conversation.dart';
import 'package:meet_up/Screens/search.dart';
import 'package:meet_up/services/auth.dart';
import 'package:meet_up/services/database.dart';

class Chatroom extends StatefulWidget {
  @override
  _ChatroomState createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream? chatRoomsStream;
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(snapshot.data.docs[index]
                      .data()["chatroomId"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(Constants.myName, ""),
                      snapshot.data.docs[index]
                          .data()["chatroomId"]);

                })
            : Container(
                color: Colors.white,
              );
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 120.0,
        elevation: 0.0,
        title: Center(
          child: Image.asset(
            "Images/Meetup.png",
            height: 200.0,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade800,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoom;
  ChatRoomTile(this.userName,this.chatRoom);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Conversation(chatRoom)));
      },
      child: Container(
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          color: Colors.teal.shade800,
          elevation: 10.0,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Center(
                      child: Text(
                    "${userName.substring(0, 1).toUpperCase()}",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
