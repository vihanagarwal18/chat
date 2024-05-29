import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  // const UserTile({super.key});
  final String text;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.text ,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    print("text of usertile is ${text}");
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration:  BoxDecoration(
          color:Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            //icon
            Icon(Icons.person),
            //user name
            Text(
              text,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


