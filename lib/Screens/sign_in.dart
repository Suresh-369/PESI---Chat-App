import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pesiapp/Screens/chatrooms.dart';
import 'package:pesiapp/Screens/forget_password.dart';
import 'package:pesiapp/common.dart';
import 'package:pesiapp/helper/helper_functions.dart';
import 'package:pesiapp/services/auth.dart';
import 'package:pesiapp/services/database.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

//  DataBaseMethods dataBaseMethods = DataBaseMethods();
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService.signInWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text).then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DataBaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
    /* HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

      dataBaseMethods.getUserByUserEmail(emailEditingController.text).then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data['name']);
        print("${(snapshotUserInfo.documents[0].data['name'])}");
      });

      await authService.signInWithEmailAndPassword(email: emailEditingController.text, password: passwordEditingController.text).then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseMethods().getUserInfo(emailEditingController.text);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return ChatRoom();
          }));
        }
      });
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SafeArea(
          child: Scaffold(
            appBar: commonAppBar(context),
            body: isLoading
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Center(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
//                          mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Container(
                                    height: 75.0,
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                                            decoration: bgColorwithShadow(),
                                            height: 48.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24.0),
                                            child: TextFormField(
                                              keyboardType: TextInputType.emailAddress,
                                              validator: (val) {
                                                return val.isEmpty
                                                    ? 'Please enter a Email id'
                                                    : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)
                                                        ? null
                                                        : 'Please provide valid Email id';
                                              },
                                              controller: emailEditingController,
                                              style: textFieldTextStyle(),
                                              decoration: textFieldsInputDecoration('email id'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Container(
                                    height: 75.0,
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                                            decoration: bgColorwithShadow(),
                                            height: 48.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 24.0),
                                            child: TextFormField(
                                              obscureText: true,
                                              validator: (val) {
                                                return val.isEmpty ? 'Please enter a password' : val.length < 8 ? 'Please enter atleast 8 characters' : null;
                                              },
                                              controller: passwordEditingController,
                                              style: textFieldTextStyle(),
                                              decoration: textFieldsInputDecoration('password'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return ForgotPassword();
                                    }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      'Forget Password ?',
                                      style: TextStyle(color: primaryColor.withGreen(-33), fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50.0),
                            GestureDetector(
                              onTap: () {
                                signIn();
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 25.0),
                                alignment: Alignment.center,
                                height: 50.0,
                                padding: EdgeInsets.symmetric(horizontal: 25.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: customShadow,
                                  borderRadius: BorderRadius.circular(33.0),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 25.0),
                            /*Container(
                              margin: EdgeInsets.symmetric(horizontal: 25.0),
                              alignment: Alignment.center,
                              height: 50.0,
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
//                          boxShadow: customShadow,
                                borderRadius: BorderRadius.circular(33.0),
                              ),
                              child: Text(
                                'Sign In with Google',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                            ),
                            SizedBox(height: 30.0),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Don\'t have an Account ?  ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggleView();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Register Now',
                                      style: TextStyle(color: primaryColor.withGreen(-33), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
