import 'package:chatly/screens/login_screen.dart';
import 'package:chatly/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatelessWidget {
  static const String id = 'chat_screen';

  final User user;

  ChatScreen({
    required this.user,
  });

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _handleSendMessage(BuildContext context) async {
    if (_messageController.text.isNotEmpty) {
      try {
        await _db.collection('messages').add({
          "id": user.uid,
          "name": user.displayName!,
          "message": _messageController.text,
          "createdAt": FieldValue.serverTimestamp(),
        });

        _messageController.text = "";
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        backgroundColor: kDarkGrey,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: kPurpleColor,
          title: const Text(
            'Chatly',
            style: TextStyle(fontFamily: 'VT323', fontSize: 32),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.id,
                  ModalRoute.withName("/"),
                );
              },
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection('messages')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("An error occured"),
                      );
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          return Row(
                            mainAxisAlignment: user.uid == doc['id'] as String
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8,
                                ),
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                decoration: BoxDecoration(
                                  color: user.uid == doc['id'] as String
                                      ? kPurpleColor
                                      : kLightGrey,
                                  borderRadius: BorderRadius.circular(
                                    16.0,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      user.uid == doc['id'] as String
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc['name'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      doc['message'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      doc['createdAt'] == null
                                          ? 'a moment ago'
                                          : timeago.format(
                                              doc['createdAt'].toDate()
                                                  as DateTime,
                                              locale: 'en',
                                            ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: Colors.grey[200],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: kLightGrey,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey[400]!,
                        width: 0.1,
                      ),
                    ),
                  ),
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          style: TextStyle(
                            color: Colors.grey[400],
                          ),
                          cursorColor: Colors.grey[400],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16.0),
                            border: InputBorder.none,
                            hintText: 'Add text',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _handleSendMessage(context),
                        icon: Icon(
                          Icons.send,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
