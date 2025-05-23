import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/components.dart';
import 'package:chat/services/chat_services/chatservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

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
  GenerativeModel? _model;
  bool _isGeminiAvailable = false;

  // Map to store sentiment results for each message by message ID
  final Map<String, String> _messageSentiments = {};

  // List to store the last 10 messages (both sender and receiver) for context-aware suggestions
  final List<Map<String, dynamic>> _lastMessages = [];

  // State variable to track if the last message was from the receiver
  bool _isLastMessageFromReceiver = false;

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
    try {
      // TODO: IMPORTANT - Add your Gemini API key here
      // To get an API key:
      // 1. Go to https://ai.google.dev/
      // 2. Create or select a project
      // 3. Get an API key
      // 4. Replace the empty string below with your API key
      const String apiKey = ''; 
      
      if (apiKey.isNotEmpty) {
        _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey,
        );
        _isGeminiAvailable = true;
      } else {
        print('Warning: Gemini API key is not configured');
        _isGeminiAvailable = false;
      }
    } catch (e) {
      print('Error initializing Gemini: $e');
      _isGeminiAvailable = false;
    }
  }

  Future<String> _analyzeSentiment(String message) async {
    if (!_isGeminiAvailable) return 'neutral';
    
    print("Analyzing sentiment: $message");
    try {
      final prompt = 'Analyze the sentiment of this message and respond with exactly one word (positive, negative, or neutral): "$message"';
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      return response.text?.toLowerCase().trim() ?? 'neutral';
    } catch (e) {
      print('Error analyzing sentiment: $e');
      return 'neutral';
    }
  }

  // Method to generate response suggestions
  Future<List<String>> _generateSuggestions() async {
    if (!_isGeminiAvailable) {
      return ["Hi", "How are you?", "Could you tell me more?", "Interesting!", "Thanks for sharing"];
    }
    
    if (_lastMessages.isEmpty) return ["Could you clarify?"];
    
    try {
      // Construct the conversation history
      String conversation = _lastMessages.map((msg) {
        String sender = msg['sender'] == _authService.getCurrentUser()!.uid ? "You" : widget.receiverEmail;
        return "$sender: ${msg['message']}";
      }).join("\n");

      // Create a prompt for the AI model
      String prompt = "$conversation\nYou should say:";

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      final suggestions = response.text
          ?.split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList() ?? ["Could you clarify?"];

      // Limit to a maximum of 5 suggestions
      if (suggestions.length > 5) {
        return suggestions.sublist(0, 5);
      }

      return suggestions;
    } catch (e) {
      print('Error generating suggestions: $e');
      return ["Hi", "How are you?", "Could you clarify?", "Interesting!", "Tell me more"]; // Fallback suggestions
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      setState(() {
        _lastMessages.add({
          'sender': _authService.getCurrentUser()!.uid,
          'message': _messageController.text,
        });
        if (_lastMessages.length > 10) {
          _lastMessages.removeAt(0);
        }
        _isLastMessageFromReceiver = false;
      });
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.receiverEmail, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black),
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
                  Divider(height: 1.0, color: Colors.grey[300]),
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

        final messages = snapshot.data!.docs;

        // Update the _lastMessages list with the latest messages
        for (var doc in messages) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String message = data["message"];
          String messageSenderID = data["senderID"];

          _lastMessages.add({
            'sender': messageSenderID,
            'message': message,
          });

          if (_lastMessages.length > 10) {
            _lastMessages.removeAt(0);
          }
        }

        // Determine if the last message was from the receiver
        if (messages.isNotEmpty) {
          Map<String, dynamic> lastMessage = (messages.last.data() as Map<String, dynamic>);
          bool lastFromReceiver = lastMessage['senderID'] != senderID;
          
          if (lastFromReceiver != _isLastMessageFromReceiver) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLastMessageFromReceiver = lastFromReceiver;
              });
            });
          }
        }

        // Scroll to bottom after receiving new messages
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

        return ListView(
          controller: _scrollController,
          children: messages.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
    String message = data["message"];
    String messageId = doc.id; // Unique ID for each message

    // Format the timestamp to display only date and time
    String formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm').format(data['timestamp'].toDate());

    return GestureDetector(
      // Only enable sentiment analysis if Gemini is available
      onTap: _isGeminiAvailable ? () async {
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
      } : null,
      child: Container(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Stack(
          children: [
            ChatBubble(
              message: message,
              isCurrentUser: isCurrentUser,
              backgroundColor: isCurrentUser ? Colors.blue[50] : Colors.grey[200],
              timestamp: formattedTimestamp,
            ),
            // Optional: Display a small sentiment icon if analyzed and Gemini is available
            if (_isGeminiAvailable && _messageSentiments.containsKey(messageId))
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

  // Modify _buildUserInput to include response suggestions conditionally
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Display response suggestions only if the last message was from the receiver
          if (_isLastMessageFromReceiver)
            FutureBuilder<List<String>>(
              future: _generateSuggestions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox.shrink();

                return Container(
                  height: 40.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.map((suggestion) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ActionChip(
                          label: Text(suggestion),
                          onPressed: () {
                            setState(() {
                              _messageController.text = suggestion;
                            });
                            myFocusNode.requestFocus();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          if (_isLastMessageFromReceiver) SizedBox(height: 8.0),
          // Existing input field and send button
          Row(
            children: [
              Expanded(
                child: MyTextField(
                  controller: _messageController,
                  hinttext: "Type a message",
                  obscureText: false,
                  focusNode: myFocusNode,
                  onSubmitted: (value) async {
                    await sendMessage();
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await sendMessage();
                },
                icon: Icon(Icons.send, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
