import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mupit/Helper_Functions/Shared_Preference_Helper.dart';

class Database {
  Future AddUserInfoToDatabase(
      String userID, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> GetUserByName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isLessThanOrEqualTo: username)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> GetUserByuserName(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: username)
        .snapshots();
  }

  Future addMessage(
      String chatRoomId, String messageID, Map messageInfo) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageID)
        .set(messageInfo);
  }

  UpdateLastMessageSend(String chatRoomId, Map lastMessageInfo) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfo);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> GetChatRoomMessages(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> GetChatRooms() async {
    String myUserName = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("time", descending: true)
        .where("users", arrayContains: myUserName)
        .snapshots();
  }

  Future<QuerySnapshot> GetUserSingle(String username) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }



}
