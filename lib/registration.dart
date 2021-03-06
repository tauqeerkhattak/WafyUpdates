import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'data.dart';
import 'home_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'my_stepper.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  bool _validating = false;
  String bloodGroupDropdown = 'O+';
  String districtDropdown = Data.districtValues[0];
  String collegeDropdown = Data.collegeValues[0];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController cicController = TextEditingController();
  TextEditingController collegeNameController = TextEditingController();
  TextEditingController cicBatchController = TextEditingController();
  DateTime dateOfBirth;
  File _image;
  final picker = ImagePicker();
  int currentStep = 0;
  bool complete = false;
  final _accountFormKey = GlobalKey<FormState>();
  final _personalFormKey = GlobalKey<FormState>();
  final _collegeFormKey = GlobalKey<FormState>();
  List<MyStep> _stepsList;
  bool passwordNotVisible = true;
  bool confirmPasswordNotVisible = true;

  @override
  void dispose () {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    houseNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    dateController.dispose();
    placeController.dispose();
    districtController.dispose();
    bloodGroupController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    cicController.dispose();
    collegeNameController.dispose();
    cicBatchController.dispose();
    super.dispose();
  }

  _buildStep () {
    _stepsList = [
      MyStep(
        title: Text(
            "Step 1",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        isActive: true,
        content: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _accountFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(0.0),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/login_background.png",
                            // width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60),
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
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 15.0,bottom: 0.0),
                    child: Text(
                      'Step 1: Account Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
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
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
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
                      controller: confirmPasswordController,
                      obscureText: confirmPasswordNotVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Confirm password:",
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
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Data.primaryColor,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              confirmPasswordNotVisible = !confirmPasswordNotVisible;
                            });
                          },
                          child: Icon(
                            (confirmPasswordNotVisible)?EvaIcons.eye:EvaIcons.eyeOff,
                            color: Data.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      MyStep(
        title: Text(
          "Step 2",
          style: TextStyle(
            color: Data.secondaryColor,
          ),
        ),
        isActive: true,
        content: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _personalFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(0.0),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/login_background.png",
                            // width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60),
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
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 15.0,bottom: 0.0),
                    child: Text(
                      'Step 2: Personal Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  InkWell(
                    child: CircleAvatar(
                      radius: 50,
                      child: CircleAvatar(
                        backgroundColor: Data.primaryColor,
                        radius: 50,
                        backgroundImage: (_image != null)?Image.file(_image, fit: BoxFit.fitHeight).image:null,
                        child: (_image != null)?null:Icon(Icons.add_a_photo,color: Data.secondaryColor,),
                      ),
                    ),
                    onTap: () {
                      print("AVATAR TAPPED");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select From: "),
                              content: Text("Please choose where to select the image from: "),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Camera"),
                                  onPressed:() {
                                    getImageFromCamera();
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("Gallery"),
                                  onPressed: () {
                                    getImageFromGallery();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String name) {
                        if (name.isEmpty || name == null) {
                          return "Name can't be empty!";
                        }
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:  Colors.white,
                        labelText: "Name:",
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
                        prefixIcon: Icon(
                          Icons.perm_identity,
                          color: Data.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String houseName) {
                        if (houseName.isEmpty || houseName == null) {
                          return "Please Enter House Name!";
                        }
                        return null;
                      },
                      controller: houseNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "House Name:",
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
                        prefixIcon: Icon(
                          Icons.home,
                          color: Data.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String fatherName) {
                        if (fatherName.isEmpty || fatherName == null) {
                          return "Please Enter Father Name!";
                        }
                        return null;
                      },
                      controller: fatherNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Father Name:",
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
                        prefixIcon: Icon(
                          Icons.people,
                          color: Data.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String motherName) {
                        if (motherName.isEmpty || motherName == null) {
                          return "Please Enter Mother Name!";
                        }
                        return null;
                      },
                      controller: motherNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Mother Name:",
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
                        prefixIcon: Icon(
                          Icons.people,
                          color: Data.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String date) {
                        if (date.isEmpty || date == null) {
                          return "Date can't be empty!";
                        }
                        return null;
                      },
                      controller: dateController,
                      onTap: () async {
                        dateOfBirth = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1980,1),
                          lastDate: DateTime.now(),
                        );
                        setState(() {
                          int month = dateOfBirth.month;
                          int day = dateOfBirth.day;
                          int year = dateOfBirth.year;
                          dateController.text = '$day - $month - $year';
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Date of Birth:",
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
                        prefixIcon: Icon(
                          Icons.cake,
                          color: Data.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String place) {
                        if (place.isEmpty || place == null) {
                          return "Place can't be empty!";
                        }
                        return null;
                      },
                      controller: placeController,
                      decoration: InputDecoration(
                        labelText: "Place:",
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
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.place,
                          color: Data.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.cyan.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    child: SizedBox(
                      height: 45,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(0.0),
                            margin: EdgeInsets.only(top: 9.0,right: 0.0, left: 7.0),
                            child: Icon(
                              Icons.location_city,
                              color: Data.primaryColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 13.0,left: 10.0),
                            child: Text(
                              "District:",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                            child: DropdownButton<String>(
                              value: districtDropdown,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.grey),
                              underline: DropdownButtonHideUnderline(
                                child: Container(),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  districtDropdown = newValue;
                                  print(districtDropdown);
                                  print(newValue);
                                });
                              },
                              items: Data.districtValues
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.cyan.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(0.0),
                          margin: EdgeInsets.only(top: 4.0,right: 9.0, left: 7.0),
                          child: Icon(
                            Icons.blur_on,
                            color: Data.primaryColor,
                          ),
                        ),
                        Container(
                          child: Text(
                            "Blood Group: ",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          child: DropdownButton<String>(
                            value: bloodGroupDropdown,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.grey),
                            underline: DropdownButtonHideUnderline(
                              child: Container(),
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                bloodGroupDropdown = newValue;
                                print(bloodGroupDropdown);
                                print(newValue);
                              });
                            },
                            items: <String>['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String phone) {
                        if (phone.isEmpty || phone == null) {
                          return "Phone can't be empty!";
                        }
                        else if(phone.length < 10) {
                          return "Please enter a valid phone number!";
                        }
                        return null;
                      },
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Data.primaryColor,
                        ),
                        labelText: "Phone Number:",
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
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String whatsapp) {
                        if (whatsapp.isEmpty || whatsapp == null) {
                          return "Whatsapp number can't be empty!";
                        }
                        else if(whatsapp.length < 10) {
                          return "Please enter a valid whatsapp number!";
                        }
                        return null;
                      },
                      controller: whatsappController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.public,
                          color: Data.primaryColor,
                        ),
                        labelText: "Whatsapp No:",
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      MyStep(
        title: Text(
          "Step 3",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        isActive: true,
        content: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _collegeFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(0.0),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/login_background.png",
                            // width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
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
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 15.0,bottom: 0.0),
                    child: Text(
                      'Step 3: College Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String cic) {
                        if (cic.isEmpty || cic == null) {
                          return "CIC Number can't be empty!";
                        }
                        return null;
                      },
                      controller: cicController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.receipt,
                          color: Data.primaryColor,
                        ),
                        labelText: "CIC Number:",
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
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Data.primaryColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    child: SizedBox(
                      height: 45.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.all(0.0),
                            margin: EdgeInsets.only(top: 9.0,right: 0.0, left: 7.0),
                            child: Icon(
                              Icons.location_city,
                              color: Data.primaryColor,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 13.0,left: 10.0),
                            child: Text(
                              "College:",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                            child: DropdownButton<String>(
                              value: collegeDropdown,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey,
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.grey),
                              underline: DropdownButtonHideUnderline(
                                child: Container(),
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  collegeDropdown = newValue;
                                  print(collegeDropdown);
                                  print(newValue);
                                });
                              },
                              items: Data.collegeValues
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0,left: 40.0,right: 40.0,bottom: 0.0),
                    child: TextFormField(
                      autofocus: false,
                      validator: (String cicBatch) {
                        if (cicBatch.isEmpty || cicBatch == null) {
                          return "CIC Batch can't be empty!";
                        }
                        return null;
                      },
                      controller: cicBatchController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.group,
                          color: Data.primaryColor,
                        ),
                        labelText: "CIC Batch:",
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  void _addDataToFirebase (String email,String password,String name,String houseName,String fatherName,String motherName,String dateOfBirth,String place,String district,String bloodGroup,String phNo,String whatsappNo,String cic,String collegeName,String cicBatch) {
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) => {
      FirebaseFirestore.instance.collection("Registered Users").doc(email).set({
        "Email": email,
        "Name": name,
        "House Name": houseName,
        "Father Name": fatherName,
        "Mother Name": motherName,
        "Date of Birth": dateOfBirth,
        "Place": place,
        "District": district,
        "Blood Group": bloodGroup,
        "Phone Number": phNo,
        "Whatsapp Number": whatsappNo,
        "CIC No": cic,
        "College Name": collegeName,
        "CIC Batch": cicBatch,
      }).then((value) {
        setState(() {
          _validating = false;
        });
        if (_image != null) {
          uploadFile();
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Account Confirmation"),
              content: Text("Account successfully created!"),
              actions: [
                TextButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Data.primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return HomePage();
                      }
                    ), (Route <dynamic> route) => false);
                  },
                ),
              ],
            );
          }
        );
      }),
    }).catchError((error) {
      setState(() {
        _validating = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Email already exist"),
              content: Text(error.toString()),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          }
      );
    });
  }

  Future uploadFile () async {
    User user = FirebaseAuth.instance.currentUser;
    String imageName = user.uid;
    StorageReference reference = FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    await uploadTask.onComplete;
    print("File Uploaded");
  }

  next () {
    currentStep + 1 != _stepsList.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildStep();
    return Scaffold(
      backgroundColor: Data.secondaryColor,
      appBar: AppBar(
        title: Text(
          "Registration",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Data.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(),
          color: Data.primaryColor,
          inAsyncCall: _validating,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Theme(
                  data: ThemeData(
                    accentColor: Data.primaryColor,
                    primarySwatch: MaterialColor(0xFFFFFFFF,<int,Color> {100: Color(0xFFFFFFFF)}),
                    canvasColor: Colors.cyan,
                    backgroundColor: Data.primaryColor,
                    primaryColorDark: Colors.white,
                    secondaryHeaderColor: Colors.white,
                    textSelectionColor: Colors.white,
                    textSelectionHandleColor: Colors.cyan,
                    colorScheme: ColorScheme.light(
                      primary: Colors.white,
                      onPrimary: Data.primaryColor,
                      primaryVariant: Colors.white,
                    ),
                  ),
                  child: MyStepper(
                    controlsBuilder:(currentStep == 2)?(BuildContext context,
                        {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15,left: 40,right: 15,bottom: 15),
                            child: FlatButton(
                              color: Data.primaryColor,
                              child: Text(
                                'REGISTER',
                                style: TextStyle(
                                  color: Data.secondaryColor,
                                ),
                              ),
                              onPressed: onStepContinue,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15,left: 15,right: 7.5,bottom: 15),
                            child: TextButton(
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(
                                  color: Colors.cyan,
                                ),
                              ),
                              onPressed: onStepCancel,
                            ),
                          ),
                        ],
                      );
                    }:null,
                    type: MyStepperType.horizontal,
                    steps: _stepsList,
                    currentStep: currentStep,
                    onStepContinue: () {
                      if(currentStep == 0) {
                        if(passwordController.text == confirmPasswordController.text) {
                          print("Next Page 1");
                          if(_accountFormKey.currentState.validate()) {
                            print("Account Details Validated!");
                            next();
                          }
                        }
                        else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("Passwords dont match, please try again!"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: Data.primaryColor,
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
                      else if (currentStep == 1) {
                        print("Next Page 2");
                        if (_personalFormKey.currentState.validate()) {
                          print("Personal Details Validated!");
                          next();
                        }
                      }
                      else if (currentStep == 2) {
                        print("Next Page 3");
                        if (_collegeFormKey.currentState.validate()) {
                          print("College Details Validated!");
                          String email = emailController.text.trim();
                          String password = passwordController.text;
                          String name = nameController.text;
                          String houseName = houseNameController.text;
                          String fatherName = fatherNameController.text;
                          String motherName = motherNameController.text;
                          String dOB = dateController.text;
                          String place = placeController.text;
                          String district = districtDropdown;
                          String bloodGroup = bloodGroupDropdown;
                          String phone = phoneController.text;
                          String whatsapp = whatsappController.text;
                          String cic = cicController.text;
                          String collegeName = collegeDropdown;
                          String cicBatch = cicBatchController.text;
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _validating = true;
                          });
                          _addDataToFirebase(email,password,name,houseName,fatherName,motherName,dOB,place,district,bloodGroup,phone,whatsapp,cic,collegeName,cicBatch);
                        }
                      }
                    },
                    onStepTapped: (step) {
                      goTo(step);
                    },
                    onStepCancel: () {
                      cancel();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
