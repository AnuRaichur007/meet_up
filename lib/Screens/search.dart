import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/Helper/constants.dart';
import 'package:meet_up/services/database.dart';
import 'conversation.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchController = new TextEditingController();

  QuerySnapshot? searchSnapshot;
  initiateSearch() async {
    await databaseMethods.getUserByUsername(searchController.text).then((val) {
      print(val.toString());
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({required String userName}) {
    print("${Constants.myName}");
    String chatRoomId = getChatRoomId(userName, Constants.myName);
    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> charRoomMap = {
      "users": users,
      "chatroomId": chatRoomId,
    };
    DatabaseMethods().createChatRoom(chatRoomId, charRoomMap);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Conversation(chatRoomId)));
  }

  Widget SearchTile({required String userName, required String userEmail}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ],
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                createChatRoomAndStartConversation(userName: userName);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.teal.shade800,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  'Message',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget searchList() {
    if (searchSnapshot != null) {
      return ListView.builder(
          itemCount: searchSnapshot!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return SearchTile(
                userName: searchSnapshot!.docs[index]['name'],
                userEmail: searchSnapshot!.docs[index]['email']);
          });
    } else {
      return Container(
        color: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        elevation: 0.0,
        title: Center(child: Text('Find your friends!')),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade900,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        fillColor: Colors.grey.shade900,
                        filled: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
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
                      padding: EdgeInsets.all(12.0),
                      child: Image.asset(
                        "Images/Search.png",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
