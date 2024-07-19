import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/components.dart';
import 'package:chat/components/my_drawer.dart';
import 'package:chat/constants/contants.dart';
import 'package:chat/services/chat_services/chatservice.dart';
import 'package:flutter/material.dart';
import 'package:chat/components/user_tile.dart';
import 'package:chat/pages/chatpage.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

class Homepage extends StatefulWidget {
  Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  String _searchQuery = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lenk_bg, // Match background color
      appBar: AppBar(
        title: Text(
          "Lenk",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        foregroundColor: Colors.grey,
      ),
      drawer: MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Consistent padding
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        var user =
                            await _chatService.getUserByEmail(_searchQuery);
                        if (user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                receiverEmail: user['email'],
                                receiverID: user['uid'],
                              ),
                            ),
                          ).then((_) {
                            // Clear the search query and refresh the state when returning from ChatPage
                            setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          });
                        } else {
                          showSnackBar(context, "Email not found", Colors.red);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildUserList()),
            ],
          ),
        ),
      ),
    );
  }

  // build a list of users except for the the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return Text('Error');
        }
        //loading

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading....");
        }

        var users = snapshot.data!
            .where((userData) =>
                userData["email"] != _authService.getCurrentUser()!.email)
            .where((userData) => userData["email"].contains(_searchQuery))
            .toList();

        return ListView(
          children: users
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return FutureBuilder(
      future: _chatService.hasMessages(userData["uid"]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.hasData && snapshot.data == true) {
          return UserTile(
            text: userData["email"],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverEmail: userData["email"],
                    receiverID: userData["uid"],
                  ),
                ),
              ).then((_) {
                // Clear the search query and refresh the state when returning from ChatPage
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              });
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}