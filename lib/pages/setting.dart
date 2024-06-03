import 'package:chat/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar:  AppBar(
        title:Text("Settings"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // switch for dark and light mode
            Text("Dark Mode"),
            CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context,listen:false).isDarkMode,
                onChanged: (value) => Provider.of<ThemeProvider>(context,listen:false).toggleTheme(),
            )
          ],
        ),
      ),
    );
  }
}


//log out
//permission
//theme
//username change option
//account info

