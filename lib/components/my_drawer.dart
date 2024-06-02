import 'package:chat/auth/auth_service.dart';
import 'package:flutter/material.dart';
// import 'package:chat/pages/register.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              //home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('H O M E'),
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              //setting list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('S E T T I N G'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(
                      '/SettingPage',
                      // MaterialPageRoute(builder: (context)=>'/SettingPage'
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: Text('L O G O U T'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    logOut();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
                child: ListTile(
                  title: Text('DELETE ACCOUNT'),
                  leading: Icon(Icons.delete),
                  onTap: () async {
                    deleteaccount();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void logOut() async {
    final _auth = AuthService();
    print("logout through drawer");
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/AuthGate',
      (_) => false,
    );
  }

  void deleteaccount() async {
    final _auth = AuthService();
    try {
      final user = _auth.getCurrentUser();
      if (user != null) {
        print("User with email ${user.email} is being deleted");
        await user.delete();
        await _auth.signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/AuthGate',
          (_) => false,
        );
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error deleting user: $e");
      // Handle specific errors if needed, e.g., re-authentication required
    }
  }
}


//delete account ke satt firestore main save kara hua data usse account ka delete karna
