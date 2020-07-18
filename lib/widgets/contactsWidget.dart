import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stagpus/Chat/ChatView/ChatScreen.dart';
import 'package:stagpus/Provider/user_provider.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/widgets/OnlineDotIndicator.dart';
import 'package:stagpus/widgets/customTile.dart';
import 'chatMethods.dart';
import 'lastmessagecontainer.dart';
import 'package:stagpus/resources/FirebaseMethods.dart';
import 'package:stagpus/Chat/ChatModel/Contact.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final FirebaseMethods _methods = FirebaseMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: _methods.getUserDetailsById(contact.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return ViewLayout(contact: user);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact
  });

  @override
  Widget build(BuildContext context) {
    // find out what Provider.of<UserProvider does)
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
        mini: false,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiver: contact,
              ),
            )),
        title: Text(
          (contact != null ? contact.email : null) != null
              ? contact.email
              : "..",
          style:
              TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
        ),
        subtitle: LastMessageContainer(
          stream: _chatMethods.fetchLastMessageBetween(
              senderId: userProvider.getUser.uid, receiverId: contact.uid),
        ),
        leading: Container(
            constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
            child: Stack(children: <Widget>[
              OnlineDotIndicator(
                uid: contact.uid,
              )
            ])));
  }
}
