import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pesiapp/helper/constants.dart';
import 'package:pesiapp/helper/helper_functions.dart';
import 'package:pesiapp/services/database.dart';
import '../common.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
//  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController messageEditingController = TextEditingController();

  Widget chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
//                  reverse: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data.documents[index].data["message"],
                      sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
                    );
                  })
              : Container();
        });
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DataBaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DataBaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          leading: Text(''),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(44),
            ),
          ),
          backgroundColor: primaryColor,
          title: Text(
            'PESI',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 5.5, fontFamily: 'Courgette', color: impColor
//            fontStyle: FontStyle.italic,
                ),
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                child: chatMessages(),
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: TextFormField(
                          controller: messageEditingController,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Type your message here...',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 15.0, right: 20.0),
                        child: Image.asset(
                          'images/send.png',
                          height: 25.0,
                          width: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: sendByMe
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 7.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0), bottomLeft: Radius.circular(25.0))),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
