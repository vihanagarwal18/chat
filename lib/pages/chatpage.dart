import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/components.dart';
import 'package:chat/constants/contants.dart';
import 'package:chat/services/chat_services/chatservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  late final GoogleGemini _geminiModel;

  // Map to store sentiment results for each message by message ID
  final Map<String, String> _messageSentiments = {};

  @override
  void initState() {
    super.initState();
    _initGemini();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 500), () => scrollDown());
      }
    });
    Future.delayed(Duration(milliseconds: 500), () => scrollDown());
  }

  void _initGemini() {
    _geminiModel =
        GoogleGemini(apiKey: 'AIzaSyCKRTkyTQ342AIW1pcXcQZ82_d7W60S_UU'); // Replace with your actual API key
  }

  Future<String> _analyzeSentiment(String message) async {
    print("Analyzing sentiment: $message");
    try {
      final response = await _geminiModel.generateFromText(
          'Analyze the sentiment of this message and respond with exactly one word (positive, negative, or neutral): "$message"');
      return response.text.toLowerCase().trim();
    } catch (e) {
      print('Error analyzing sentiment: $e');
      return 'neutral';
    }
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

  Future<void> sendMessage() async {
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
          return Center(child: Text("Error loading messages."));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    String message = data["message"];
    String messageId = doc.id; // Unique ID for each message

    return GestureDetector(
      onTap: () async {
        // Check if sentiment for this message is already analyzed
        if (_messageSentiments.containsKey(messageId)) {
          // Display existing sentiment
          _showSentimentDialog(message, _messageSentiments[messageId]!);
        } else {
          // Show loading indicator
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );

          // Analyze sentiment
          String sentiment = await _analyzeSentiment(message);
          setState(() {
            _messageSentiments[messageId] = sentiment;
          });

          // Dismiss loading indicator
          Navigator.of(context).pop();

          // Show sentiment dialog
          _showSentimentDialog(message, sentiment);
        }
      },
      child: Container(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Stack(
          children: [
            ChatBubble(
              message: message,
              isCurrentUser: isCurrentUser,
            ),
            // Optional: Display a small sentiment icon if analyzed
            if (_messageSentiments.containsKey(messageId))
              Positioned(
                bottom: 0,
                right: isCurrentUser ? 0 : null,
                left: isCurrentUser ? null : 0,
                child: Icon(
                  _getSentimentIcon(_messageSentiments[messageId]!),
                  size: 16.0,
                  color: _getSentimentColor(_messageSentiments[messageId]!),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper method to get sentiment icon
  IconData _getSentimentIcon(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return Icons.sentiment_satisfied;
      case 'negative':
        return Icons.sentiment_dissatisfied;
      case 'neutral':
      default:
        return Icons.sentiment_neutral;
    }
  }

  // Helper method to get sentiment color
  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'positive':
        return Colors.green;
      case 'negative':
        return Colors.red;
      case 'neutral':
      default:
        return Colors.grey;
    }
  }

  // Method to display sentiment in a dialog
  void _showSentimentDialog(String message, String sentiment) {
    String displaySentiment;
    IconData sentimentIcon;
    Color sentimentColor;

    switch (sentiment) {
      case 'positive':
        sentimentIcon = Icons.sentiment_satisfied;
        sentimentColor = Colors.green;
        displaySentiment = "Positive 😊";
        break;
      case 'negative':
        sentimentIcon = Icons.sentiment_dissatisfied;
        sentimentColor = Colors.red;
        displaySentiment = "Negative 😞";
        break;
      case 'neutral':
      default:
        sentimentIcon = Icons.sentiment_neutral;
        sentimentColor = Colors.grey;
        displaySentiment = "Neutral 😐";
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(sentimentIcon, color: sentimentColor),
              SizedBox(width: 8.0),
              Text("Sentiment Analysis"),
            ],
          ),
          content: Text(
            "\"$message\"\n\nSentiment: $displaySentiment",
            style: TextStyle(fontSize: 16.0),
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
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
              await sendMessage();
            },
            icon: Icon(Icons.arrow_upward, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
