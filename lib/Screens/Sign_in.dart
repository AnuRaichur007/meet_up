import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meet_up/Helper/helperFunction.dart';
import 'package:meet_up/services/auth.dart';
import 'package:meet_up/services/database.dart';

import 'chatroom.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 200.0,
        backgroundColor: Colors.black,
        title: Image(
          fit: BoxFit.fitWidth,
          height: 375.0,
          image: AssetImage('Images/Meetup.png'),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 100.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: TextFormField(
                    validator: (val) =>
                        val!.isEmpty ? 'This field cannot be empty' : null,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (val) => val!.isEmpty || val.length < 6
                        ? 'This field cannot be empty'
                        : null,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 15.0,
                      ),
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      filled: true,
                      fillColor: Colors.grey.shade800,
                    ),
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 120.0),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal.shade900),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      HelperFunctions.saveUserEmailSharedPreference(email);
                      databaseMethods.getUserByUserEmail(email).then((val) {
                        snapshotUserInfo = val;
                        HelperFunctions.saveUserNameSharedPreference(
                            snapshotUserInfo!.docs[0]['name']);
                        print("${snapshotUserInfo!.docs[0]['name']}");
                      });
                      setState(() {
                        isLoading = true;
                      });

                      authMethods
                          .signInWithEmailAndPassword(email, password)
                          .then((val) async {
                        if (val != null) {
                          HelperFunctions.saveUserLoggedInSharedPreference(
                              true);
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Chatroom()));
                        }
                      });
                    }
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 75.0)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.teal.shade900),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.toggle();
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.teal.shade600, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
