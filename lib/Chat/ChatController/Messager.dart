import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stagpus/models/user.dart';
import 'package:stagpus/pages/home.dart';

class Messenger extends StatefulWidget {
  final User currentUser;

  const Messenger({Key key, this.currentUser}) : super(key: key);

  @override
  _MessengerState createState() => _MessengerState();
  
}

class _MessengerState extends State<Messenger>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance; 

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    if(messageController.text.length > 0 ) {
      await _firestore.collection('messages').add({
        'from': currentUser.email,
        'text': messageController.text,
        'date': DateTime.now().toIso8601String().toString(),
      });
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,curve: Curves.easeOut, duration: const Duration(milliseconds:0));
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Surrey Chat"),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('messages').orderBy('date').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator()
                      );
                    }
                     List<DocumentSnapshot> docs = snapshot.data.documents;
                     List<Widget> messages = docs.map((doc) => Message(
                       from: doc.data['from'],
                       text: doc.data['text'],
                       me: widget.currentUser.email == doc.data['from']
                     )).toList(); 
                    return ListView(
                        controller: scrollController,
                        children: <Widget> [
                          ...messages,
                        ],
                      );
                    }
                ),
              ),
              Container(
                decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blueAccent, Colors.cyan])
      ),
                child: Row(
                  children: <Widget> [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) => callback(),
                        decoration: InputDecoration(
                          hintText: "Write your message here...",
                          border: const OutlineInputBorder(),
                        ),
                        controller: messageController,
                      ),
                    ),
                    SendButton(
                      text: "Send",
                      callback: callback,
                    )
                  ]
                )
              )
            ]
          )
        )
    );
  }
  
}

class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.blue,
      onPressed: callback,
      child: Text(text),
    );
  }
  
}
class Message extends StatelessWidget {
  final String from;
  final String text; 
  final bool me;

  const Message({Key key, this.from, this.text, this.me}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            from,
          ),
          Material(
            color: me ?  Colors.teal : Colors.red, 
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(
                text,
              )
            )
          )
        ]
      ),
    );
  }
  

}