import 'package:chat/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //get user stream

  /*
  [
    List<Map<String,dynamic>={
      'email':test@gmail.com,
      'id':''
     },
     List<Map<String,dynamic>={
      'email':test2@gmail.com,
      'id':''
     }
   ]
  */
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // going through each individual user
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currrentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //create a new message

    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currrentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    // construct chat room ID for the 2 user(sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); //sort the ids (this ensure the chatRoomID us the same for any 2 people
    String chatRoomID = ids.join('_');

    // add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }
  //get message

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatroom ID for the 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<bool> hasMessages(String userId) async {
    var currentUserId = _auth.currentUser!.uid;
    var chatRoomID = [currentUserId, userId]..sort();
    var messages = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID.join('_'))
        .collection('messages')
        .get();

    return messages.docs.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    var userSnapshot = await _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      return userSnapshot.docs.first.data();
    } else {
      return null;
    }
  }
}
