import 'package:flutter/material.dart';
import 'package:pesiapp/Screens/chat.dart';
import 'package:pesiapp/Screens/search.dart';
import 'package:pesiapp/common.dart';
import 'package:pesiapp/helper/authenticate.dart';
import 'package:pesiapp/helper/constants.dart';
import 'package:pesiapp/helper/helper_functions.dart';
import 'package:pesiapp/services/auth.dart';
import 'package:pesiapp/services/database.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;
//  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 30.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ChatRoomsTile(
                          userName: snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                          chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                        );
                      },
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }

  // This function will be executed whenever the screen first starts
  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DataBaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 5.5,
              fontFamily: 'Courgette',
              color: impColor,
//            fontStyle: FontStyle.italic,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                AuthService().signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return Authenticate();
                }));
              },
              child: Container(
                padding: EdgeInsets.only(right: 30.0),
                child: Icon(
                  Icons.exit_to_app,
                  color: impColor,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Search();
            }));
          },
        ),
        body: chatRoomList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile({@required this.userName, @required this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Chat(chatRoomId: chatRoomId);
        }));
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(25.0)),
        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0),
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 35.0,
              width: 35.0,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(35.0),
                boxShadow: [BoxShadow(color: Colors.black38, offset: Offset(3, 3), blurRadius: 3)],
              ),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              userName,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
