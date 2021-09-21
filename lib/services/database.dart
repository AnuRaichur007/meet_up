import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("Users").add(userMap);
  }

  createChatRoom(String charRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(charRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  addConversationMessages(String chatRoomId, messageMap) {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
