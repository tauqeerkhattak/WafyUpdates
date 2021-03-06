import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:wafy_updates/registration.dart';
import 'data.dart';
import 'home_page.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Data.primaryColor,
      ),
      body: LoginBody(),
    );
  }
}

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool emailAlreadyExist = false;
  bool wrongPassword = false;
  bool passwordNotVisible = true;
  bool _validating = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _validating,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 10,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        "assets/login_background.png",
                        // width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        scale: 0.1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Data.secondaryColor,
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 13,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0,left: 40.0,right: 40.0,bottom: 0.0),
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Email:",
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            errorText: emailAlreadyExist?'Email does not exist!':null,
                            prefixIcon: Icon(
                              Icons.person,
                              color: Data.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                        child: TextFormField(
                          obscureText: passwordNotVisible,
                          validator: (String password) {
                            if (password.isEmpty || password == null) {
                              return "Password can't be empty!";
                            }
                            else if(password.length < 8) {
                              return "Password can't be less than 8 characters!";
                            }
                            return null;
                          },
                          controller: _passwordController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            errorText: wrongPassword?'Incorrect password!':null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
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
                            labelText: "Password:",
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.cyan.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0,left: 40.0,right: 40.0,bottom: 0.0),
                        child: SizedBox(
                          height: 45,
                          child: RaisedButton(
                            child: Text("Login"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                color: Data.primaryColor,
                                width: 2.5,
                              ),
                            ),
                            color: Data.primaryColor,
                            textColor: Data.secondaryColor,
                            onPressed: () {
                              if(_formKey.currentState.validate()) {
                                String email = _emailController.text;
                                String password = _passwordController.text;
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  _validating = true;
                                });
                                FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
                                  setState(() {
                                    _validating = false;
                                  });
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return HomePage();
                                      }
                                  ));
                                }).catchError((error) {
                                  setState(() {
                                    _validating = false;
                                  });
                                  if (error.code == 'user-not-found') {
                                    setState(() {
                                      emailAlreadyExist = true;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      emailAlreadyExist = false;
                                    });
                                  }
                                  if (error.code == 'wrong-password') {
                                    setState(() {
                                      wrongPassword = true;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      wrongPassword = false;
                                    });
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                margin: EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Registration();
                            }
                        ));
                      },
                      child: Text(
                        'Create one now! ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Data.primaryColor,
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
