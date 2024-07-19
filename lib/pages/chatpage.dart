import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/components.dart';
import 'package:chat/constants/contants.dart';
import 'package:chat/services/chat_services/chatservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lenk_bg,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0.0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double containerWidth = constraints.maxWidth > 600
              ? constraints.maxWidth * 0.8
              : constraints.maxWidth * 0.95;

          return Center(
            child: Container(
              width: containerWidth,
              child: Column(
                children: [
                  Expanded(child: _buildMessageList()),
                  _buildUserInput(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading....");
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hinttext: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.arrow_upward, color: Colors.green),
          ),
        ],
      ),
    );
  }
}