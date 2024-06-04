import 'package:chat/auth/auth_service.dart';
import 'package:chat/components/my_drawer.dart';
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
  //chat and auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        foregroundColor: Colors.grey, // arrow vagra ka colour
      ),
      drawer: MyDrawer(),
      body: SafeArea(

        child: _buildUserList(),
        // child: LayoutBuilder(
        //   builder: (context, constraints) {
        //     double containerWidth = constraints.maxWidth > 600
        //         ? constraints.maxWidth * 0.8
        //         : constraints.maxWidth * 0.95;
        //
        //     return Center(
        //       child: Container(
        //         width: containerWidth,
        //         child: _buildUserList(),
        //       ),
        //     );
        //   },
        // ),
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
        //return list view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    print("no of users are ${userData.length}");
    print(userData);
    //display all users
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          //tapped on a user to got to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container(
        color: Colors.green,
      );
    }
  }
}


//users which are stored in firebase store will only be displayed here