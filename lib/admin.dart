import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'admin_control.dart';
import 'data.dart';

class AdminLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Data.primaryColor,
      appBar: AppBar(
        backgroundColor: Data.primaryColor,
        title:Text(
          "Admin Login",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: AdminLoginBody(),
    );
  }
}

class AdminLoginBody extends StatefulWidget {
  @override
  _AdminLoginBodyState createState() => _AdminLoginBodyState();
}

class _AdminLoginBodyState extends State<AdminLoginBody> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordNotVisible = true;
  String adminEmail;
  String adminPassword;

  getAdminEmail (String enteredEmail) {
    FirebaseFirestore.instance.collection("Admins").doc(enteredEmail).get().then((value) {
      adminEmail = value.get('email');
    });
  }

  getAdminPassword (String enteredEmail) async {
    await FirebaseFirestore.instance.collection('Admins').doc(enteredEmail).get().then((value) {
      adminPassword = value.get('password');
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAdminPassword('wafyfeeds@gmail.com');
    getAdminEmail('wafyfeeds@gmail.com');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    validator: (String email) {
                      if (email.isEmpty || email == null) {
                        return "Email can't be empty!";
                      }
                      else if(!(email.contains("@"))) {
                        return "Please enter a valid email!";
                      }
                      else if (!(email.contains(".com"))) {
                        return "Please enter a valid email!";
                      }
                      return null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Email:",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Data.primaryColor,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.cyan.shade300,
                          width: 1.5,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    autofocus: false,
                    validator: (String password) {
                      if (password.isEmpty || password == null) {
                        return "Password can't be empty!";
                      }
                      else if(password.length < 8) {
                        return "Length of password must be equal or greater than 8!";
                      }
                      return null;
                    },
                    controller: passwordController,
                    obscureText: passwordNotVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Password:",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.cyan.shade300,
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Data.primaryColor,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passwordNotVisible = !passwordNotVisible;
                          });
                        },
                        child: Icon(
                          (passwordNotVisible)?EvaIcons.eye:EvaIcons.eyeOff,
                          color: Data.primaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: SizedBox(
                    height: 45,
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          color: Data.primaryColor,
                        ),
                      ),
                      color: Data.secondaryColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Data.primaryColor,
                          width: 2.5,
                        ),
                      ),
                      onPressed: () async {
                        String email = emailController.text;
                        String password = passwordController.text;
                        if(_formKey.currentState.validate()) {
                          if (email == adminEmail && password == adminPassword) {
                            print('success!');
                            emailController.text = '';
                            passwordController.text = '';
                            Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AdminControl();
                              }
                            ));
                          }
                          else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Email or password is wrong! Please try again.'),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Data.primaryColor,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              }
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
