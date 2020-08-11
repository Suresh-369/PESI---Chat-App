import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pesiapp/common.dart';
import 'package:pesiapp/helper/constants.dart';
import 'package:pesiapp/helper/helper_functions.dart';
import 'package:pesiapp/services/database.dart';
import 'chat.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  TextEditingController searchEditingController = TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await dataBaseMethods.searchByName(searchEditingController.text).then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return userTile(
                searchResultSnapshot.documents[index].data["userName"],
                searchResultSnapshot.documents[index].data["userEmail"],
              );
            })
        : Container();
  }

  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    dataBaseMethods.addChatRoom(chatRoom, chatRoomId);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Chat(chatRoomId: chatRoomId);
    }));
  }

  Widget userTile(String userName, String userEmail) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          height: 120.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        userName,
                        style: TextStyle(color: primaryColor, fontSize: 14.0, letterSpacing: 0.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        userEmail,
                        style: TextStyle(color: primaryColor, fontSize: 14.0, letterSpacing: 0.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  sendMessage(userName);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 22.0),
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    'Message',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: commonAppBar(context),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 35.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25.0),
                              child: TextField(
                                controller: searchEditingController,
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                                decoration: textFieldsInputDecoration('search username'),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              initiateSearch();
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 15.0, right: 20.0),
                              height: 25.0,
                              width: 70.0,
//                        margin: EdgeInsets.only(right: 15.0),
                              child: Image.asset('images/search.png'),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    userList(),
                  ],
                ),
              ),
      ),
    );
  }
}
