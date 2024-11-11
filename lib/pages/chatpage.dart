import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/components.dart';
import 'package:chat/constants/contants.dart';
import 'package:chat/services/chat_services/chatservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  String _sentiment = '';
  String _insight = '';

  // Function to get sentiment analysis
  Future<void> getSentimentAnalysis(String message) async {
    print("Sending message to sentiment analysis API");
    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=apikey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Assuming the response contains a sentiment field
      setState(() {
        _sentiment = data['sentiment'] ?? 'Unknown';
      });
    } else {
      setState(() {
        _sentiment = 'Error fetching sentiment';
      });
    }
  }

  // Function to get AI insight
  Future<void> getAIInsight(String message) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=apikey',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": message}
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data); // Log the response for debugging
    } else {
      print("dfdsf");
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  // Function to collect the last 10 messages
  List<String> getLastMessages(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['message'] as String)
        .toList()
        .reversed
        .take(10)
        .toList();
  }

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
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
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
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
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

  Future<void> getSentimentOfLastMessage(QuerySnapshot snapshot) async {
    // Get the last message
    String lastMessage = (snapshot.docs.last.data()
        as Map<String, dynamic>)['message'] as String;

    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=apikey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": lastMessage}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Assuming the response contains a sentiment field
      setState(() {
        _sentiment = data['sentiment'] ?? 'Unknown';
      });
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      setState(() {
        _sentiment = 'Error fetching sentiment';
      });
    }
  }

  Widget _buildUserInput() {
    return Column(
      children: [
        if (_sentiment.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sentiment: $_sentiment',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        Padding(
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
                onPressed: () async {
                  await getSentimentAnalysis(_messageController.text);
                  sendMessage();
                },
                icon: Icon(Icons.arrow_upward, color: Colors.green),
              ),
              IconButton(
                onPressed: () async {
                  // Assuming you have a way to access the current message snapshot
                  QuerySnapshot snapshot = await _chatService
                      .getMessages(
                          widget.receiverID, _authService.getCurrentUser()!.uid)
                      .first;
                  await getSentimentOfLastMessage(snapshot);
                },
                icon: Icon(Icons.lightbulb, color: Colors.yellow),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
