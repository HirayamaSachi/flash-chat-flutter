import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const id='chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth=FirebaseAuth.instance;
  User loginUser;
  String _messageText;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  final _controller=TextEditingController();

  void getCurrentUser() {
  try {
  final currentUser=_auth.currentUser;
  setState(() {
    if (currentUser!=null) {
      loginUser=currentUser;
    }
  });
} catch (e) {
  print(e);
}
}

  void getMessageStream()async{
    await for (var snapshot in await _firestore.collection('messages').snapshots()) {
      for (var messages in snapshot.docs) {
      }
    }
  }

@override
  void initState() {
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    getMessageStream();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
              StreamBuilder(
              builder: ((context, snapshot) {
                List<messageBubble>messageWidgets=[];
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
              }
                final docs=snapshot.data.docs;
                for (var message in docs) {
                  final text=message.data()['text'];
                  final sender=message.data()['sender'];

                  final messageWidget=(_auth.currentUser.email==sender)?messageBubble(text: text, sender: sender,isMe: true,):messageBubble(text: text, sender: sender,isMe: false,);
                  messageWidgets.add(messageWidget);
                }
                for (var e in messageWidgets) {
                }

                return Expanded(child: ListView(children: messageWidgets,reverse: true,));
              }),
              stream: _firestore.collection('messages').orderBy('created_at',descending: true).snapshots(),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        _messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_messageText!=null && _messageText!="") {
                        _firestore.collection('messages').add(
                            {'sender': loginUser.email, 'text': _messageText,'created_at':Timestamp.fromDate(DateTime.now())});
                      }
                      _messageText=null;
                      _controller.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageBubble extends StatelessWidget {
  const messageBubble({
    Key key,
    @required this.text,
    @required this.sender,
    @required this.isMe,
  }) : super(key: key);

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: (isMe)?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: 150,
                decoration: (isMe)?BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30) ), color: Colors.lightBlue):
                    BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30) ), color: Colors.grey),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text(
                  '$text',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )),
          ),
          Text('$sender',style: TextStyle(fontSize: 12,color: Colors.grey),)
        ],
      ),
    );
  }
}
