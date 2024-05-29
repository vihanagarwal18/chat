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
  const ChatPage({
    super.key,
    required this.receiverEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(receiverEmail),
      ),
    );
  }
}

