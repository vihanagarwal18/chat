import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/components.dart';
import 'package:chat/services/chat_services/chatservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   late final String receiverEmail;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:Text(receiverEmail),
//       ),
//     );
//   }
// }


class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  //text controller
  final TextEditingController _messageController=TextEditingController();

  //chat & auth services
  final ChatService _chatService=ChatService();
  final AuthService _authService=AuthService();

  //send message
  void sendMessage() async {
    //if there is something inside the textfield
    if(_messageController.text.isNotEmpty){
      //send the message
      await _chatService.sendMessage(receiverID, _messageController.text);

      //clear text controller after sending the message
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:Text(receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          //display all messages
          
          Expanded(
              child: _buildMessageList(),
          ),
          //user input

          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList(){
    String senderID =_authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(receiverID,senderID),

        builder: (context,snapshot){
          //errors
          if(snapshot.hasError){
            return Text("Error");
          }
          //loading
          if(snapshot.connectionState==ConnectionState.waiting){
            return Text("Loading....");
          }

          //return list view
          return ListView(
            children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        }
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String,dynamic> data=doc.data() as Map<String,dynamic>;

    //is current user
    bool isCurrentUser =data['senderID'] ==_authService.getCurrentUser()!.uid;


    // align message to the right if sender is the current user .otherwise left
    var alignment =isCurrentUser ? Alignment.centerRight :Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start ,
        children: [
          ChatBubble(
              message: data["message"],
              isCurrentUser: isCurrentUser
          ),
        ],
      ),
    );
  }

  //build message input
  Widget _buildUserInput(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield should take up most of the space
          Expanded(
              child: MyTextField(
                controller:_messageController,
                hinttext: "Type a message",
                obscureText:false,
              ),
          ),
          //sendbutton

          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: sendMessage,
                icon: Icon(
                    Icons.arrow_upward,
                color: Colors.white,
                ),
            ),
          ),
        ],
      ),
    );
  }
}

