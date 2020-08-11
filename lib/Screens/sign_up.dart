import 'package:flutter/material.dart';
import 'package:pesiapp/Screens/chatrooms.dart';
import 'package:pesiapp/helper/helper_functions.dart';
import 'package:pesiapp/services/auth.dart';
import 'package:pesiapp/services/database.dart';
import '../common.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  AuthService authService = AuthService();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signUp() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text, passwordEditingController.text).then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text,
            "userEmail": emailEditingController.text,
          };

          dataBaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
          HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return ChatRoom();
          }));
        }
      });
    }
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
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
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
                                              validator: (val) {
                                                return val.isEmpty ? 'Please enter a username' : null;
                                              },
                                              controller: usernameEditingController,
                                              style: textFieldTextStyle(),
                                              decoration: textFieldsInputDecoration('username'),
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
                            SizedBox(height: 50.0),
                            GestureDetector(
                              onTap: () {
                                signUp();
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
                                  'Sign Up',
                                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0),
                                ),
                              ),
                            ),
                            SizedBox(height: 25.0),
/*                            Container(
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
                                'Sign Up with Google',
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0),
                              ),
                            ),
                            SizedBox(height: 30.0),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Already have an Account ?  ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggleView();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Sign In Here',
                                      style: TextStyle(
                                        color: primaryColor.withGreen(-33),
                                        fontWeight: FontWeight.bold,
                                      ),
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
