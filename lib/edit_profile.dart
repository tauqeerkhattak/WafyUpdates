import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'data.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Data.primaryColor,
        title: Text(
          'Edit Profile',
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
      body: EditProfileBody(),
    );
  }
}

class EditProfileBody extends StatefulWidget {
  @override
  _EditProfileBodyState createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {

  TextEditingController emailController = TextEditingController();
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
  var _formKey = GlobalKey<FormState>();
  DateTime dateOfBirth;
  File _image;
  final picker = ImagePicker();
  String profileURL = "https://i.ibb.co/59tx4Xc/avatar.webp";
  String districtDropdown = Data.districtValues[0];
  String bloodGroupDropdown = 'O+';
  String collegeDropdown = Data.collegeValues[0];
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("Registered Users");

  _updateDataInFirebase (String email, String name, String houseName, String fatherName, String motherName, String date, String place, String district, String bloodGroup, String phone, String whatsapp, String cic, String collegeName, String cicBatch) {
    FirebaseFirestore.instance.collection("Registered Users").doc(email).update({
      "Email": email,
      "Name": name,
      "House Name": houseName,
      "Father Name": fatherName,
      "Mother Name": motherName,
      "Date of Birth": date,
      "Place": place,
      "District": district,
      "Blood Group": bloodGroup,
      "Phone Number": phone,
      "Whatsapp Number": whatsapp,
      "CIC No": cic,
      "College Name": collegeName,
      "CIC Batch": cicBatch,
    }).then((value) {
      if (_image != null) {
        uploadFile();

      }
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success!"),
            content: Text("Profile successfully updated!"),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void initState() {
    getAllValues();
    super.initState();
  }

  @override
  void dispose () {
    emailController.dispose();
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

  getAllValues () async {
    User user = FirebaseAuth.instance.currentUser;
    var value = await collectionReference.doc(user.email).get();
    emailController.text = value.get("Email");
    nameController.text = value.get("Name");
    houseNameController.text = value.get("House Name");
    fatherNameController.text = value.get("Father Name");
    motherNameController.text = value.get("Mother Name");
    dateController.text = value.get("Date of Birth");
    placeController.text = value.get("Place");
    districtDropdown = value.get("District");
    bloodGroupController.text = value.get("Blood Group");
    phoneController.text = value.get("Phone Number");
    whatsappController.text = value.get("Whatsapp Number");
    cicController.text = value.get("CIC No");
    setState(() {
      collegeDropdown = value.get("College Name");
    });
    cicBatchController.text = value.get("CIC Batch");
    profileURL = await FirebaseStorage.instance.ref().child(FirebaseAuth.instance.currentUser.uid).getDownloadURL();
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

  Future uploadFile () async {
    User user = FirebaseAuth.instance.currentUser;
    String imageName = user.uid;
    StorageReference reference = FirebaseStorage.instance.ref().child(imageName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    await uploadTask.onComplete;
    print("File Uploaded");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Data.primaryColor,
                    backgroundImage: (_image != null)?FileImage(_image):null,
                    child: (_image != null)?null:Icon(Icons.add_a_photo,color: Colors.white,),
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
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  enabled: false,
                  autofocus: false,
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Email:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Name:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.perm_identity,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "House Name:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.home,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Father Name:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.people,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Mother Name:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.people,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Date of Birth:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.cake,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    labelText: "Place:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.place,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Colors.black45,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
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
                            color: Data.primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                        child: DropdownButton<String>(
                          value: districtDropdown,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
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
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Colors.black45,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      // alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(0.0),
                      margin: EdgeInsets.only(right: 9.0, left: 7.0),
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
                          color: Data.primaryColor,
                        ),
                      ),
                    ),
                    Container(
                      child: DropdownButton<String>(
                        value: bloodGroupDropdown,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
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
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Data.primaryColor,
                    ),
                    labelText: "Phone Number:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.public,
                      color: Data.primaryColor,
                    ),
                    labelText: "Whatsapp No:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
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
                  validator: (String cic) {
                    if (cic.isEmpty || cic == null) {
                      return "CIC Number can't be empty!";
                    }
                    return null;
                  },
                  controller: cicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.receipt,
                      color: Data.primaryColor,
                    ),
                    labelText: "CIC Number:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Colors.black45,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
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
                            color: Data.primaryColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                        child: DropdownButton<String>(
                          value: collegeDropdown,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black),
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
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 10.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.group,
                      color: Data.primaryColor,
                    ),
                    labelText: "CIC Batch:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 0.0),
                child: RaisedButton(
                  child: Text("Update"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Data.primaryColor,
                      width: 2.5,
                    ),
                  ),
                  color: Data.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      String email = emailController.text;
                      String name = nameController.text;
                      String houseName = houseNameController.text;
                      String fatherName = fatherNameController.text;
                      String motherName = motherNameController.text;
                      String dateOfBirth = dateController.text;
                      String place = placeController.text;
                      String district = districtDropdown;
                      String bloodGroup = bloodGroupDropdown;
                      String phone = phoneController.text;
                      String whatsapp = whatsappController.text;
                      String cic = cicController.text;
                      String college = collegeDropdown;
                      String batch = cicBatchController.text;
                      _updateDataInFirebase(email, name, houseName, fatherName, motherName, dateOfBirth, place, district, bloodGroup, phone, whatsapp, cic, college, batch);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ) ;
  }
}
