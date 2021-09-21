import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:meet_up/Helper/helperFunction.dart';
import 'package:meet_up/Screens/Home.dart';
import 'package:meet_up/Screens/chatroom.dart';
import 'package:meet_up/services/auth.dart';
import 'package:meet_up/services/database.dart';
import 'package:meet_up/shared/loading.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String username = '';
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

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
      body: isLoading
          ? Loading()
          : SingleChildScrollView(
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
                          validator: (val) => val!.length < 3
                              ? 'Enter Username +3 characters!'
                              : null,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Username',
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
                            setState(() => username = val);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Enter correct email";
                          },
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
                              ? 'Password must be atleast 6 characters!'
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
                      SizedBox(height: 40.0),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 120.0),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal.shade800),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Map<String, String> userInfoMap = {
                              "name": username,
                              "email": email,
                            };
                            HelperFunctions.saveUserEmailSharedPreference(
                                email);
                            HelperFunctions.saveUserNameSharedPreference(
                                username);

                            setState(() {
                              isLoading = true;
                            });
                            authMethods
                                .signUpWithEmailAndPassword(email, password)
                                .then((val) {
                              databaseMethods.uploadUserInfo(userInfoMap);
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Menu()));
                            });
                          }
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 75.0)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal.shade800),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Sign Up with Google',
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
                            "Already have an account?",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.toggle();
                            },
                            child: Text(
                              "SignIn",
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
