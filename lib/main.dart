import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //---------------------------------------------
  var nameText;
  var rollText;
  var messageText;
  final messageTextController1 = TextEditingController();
  final messageTextController2 = TextEditingController();
  final messageTextController3 = TextEditingController();

  //get save message from firebase database-----------
  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   for (var message in messages.documents) {
  //     print(message.data);
  //   }
  // }
  //auto get data from firebase-------------
  // void messageStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.documents) {
  //       print(message.data);
  //     }
  //   }
  // }

  //---------------------------------------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            MessageStream(),
            TextField(
              controller: messageTextController1,
              onChanged: (value) {
                messageText = value;
              },
            ),
            TextField(
              controller: messageTextController2,
              onChanged: (value) {
                rollText = value;
              },
            ),
            TextField(
              controller: messageTextController3,
              onChanged: (value) {
                nameText = value;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  messageTextController1.clear();
                  messageTextController2.clear();
                  messageTextController3.clear();
                  _firestore.collection('messages').add({
                    'name': nameText,
                    'rollno': rollText,
                    'text': messageText,
                  });
                },
                child: Text('send')),
            ElevatedButton(
                onPressed: () {
                  // getMessages();
                  // messageStream();
                },
                child: Text('get data')),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final rollText = message.data['rollno'];
          final nameText = message.data['name'];

          final messageBubble = MessageBubble(
            text: messageText,
            rollno: rollText,
            name: nameText,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

//-------------Design Part---------------------------------
class MessageBubble extends StatefulWidget {
  MessageBubble({required this.text, required this.rollno, required this.name});
  final String text;
  final String rollno;
  final String name;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            // formattedDate,
            "send",
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          //material design ----------------------
          InkWell(
            onTap: () {
              print('clicked ${widget.text}');
            },
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      widget.text,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      widget.rollno,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    Text(
                      widget.name,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
