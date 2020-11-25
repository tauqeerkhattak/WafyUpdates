import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'data.dart';

class EditCollege extends StatelessWidget {

  QueryDocumentSnapshot snapshot;

  EditCollege(QueryDocumentSnapshot snapshot) {
    this.snapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Colleges",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Data.primaryColor,
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
      body: EditCollegesBody(snapshot),
    );
  }
}

class EditCollegesBody extends StatefulWidget {

  QueryDocumentSnapshot snapshot;

  EditCollegesBody(QueryDocumentSnapshot snapshot) {
    this.snapshot = snapshot;
  }

  @override
  _EditCollegesBodyState createState() => _EditCollegesBodyState(snapshot);
}

class _EditCollegesBodyState extends State<EditCollegesBody> {
  String collegeTypeDropdown = 'Wafy';
  String districtDropdown = Data.districtValues[0];
  String starRatingDropdown = '\u2605 \u2605 \u2605 \u2605 \u2605';
  TextEditingController collegeNameController = TextEditingController();
  TextEditingController affiliationNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contact1Controller = TextEditingController();
  TextEditingController contact2Controller = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime dateOfBirth;
  File _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  QueryDocumentSnapshot snapshot;
  String url;

  _EditCollegesBodyState(QueryDocumentSnapshot snapshot) {
    this.snapshot = snapshot;
  }

  @override
  void dispose() {
    collegeNameController.dispose();
    affiliationNoController.dispose();
    addressController.dispose();
    emailController.dispose();
    contact1Controller.dispose();
    contact2Controller.dispose();
    locationController.dispose();
    super.dispose();
  }

  _updateData (String rating,String affiliation, String address, String district, String email, String contact1, String contact2, String location, String collegeType) async {
    String downloadReference;
    if(_image != null) {
     downloadReference = await uploadFile(snapshot.get('Affiliation No'));
     FirebaseFirestore.instance.collection("Colleges").doc(snapshot.get('Affiliation No')).update({
       'Ratings': rating,
       'Affiliation No': affiliation,
       'Address': address,
       'District': district,
       'Email': email,
       'Contact # 1': contact1,
       'Contact # 2': contact2,
       "Location": location,
       'College Type': collegeType,
       'URL': downloadReference,
     }).then((value) {
       Navigator.pop(context);
       showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             title: Text("Success!"),
             content: Text("All the changes have been updated!."),
             actions: [
               TextButton(
                 child: Text(
                   'Ok',
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
         },
       );
     });
    }
    else {
      FirebaseFirestore.instance.collection("Colleges").doc(snapshot.get('Affiliation No')).update({
        'Ratings': rating,
        'Affiliation No': affiliation,
        'Address': address,
        'District': district,
        'Email': email,
        'Contact # 1': contact1,
        'Contact # 2': contact2,
        "Location": location,
        'College Type': collegeType,
      }).then((value) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success!"),
              content: Text("All the changes have been updated!."),
              actions: [
                TextButton(
                  child: Text(
                    'Ok',
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
          },
        );
      });
    }
  }

  Future uploadFile (String collegeName) async {
    StorageReference reference = FirebaseStorage.instance.ref().child("Colleges").child(collegeName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    await uploadTask.onComplete;
    var url = FirebaseStorage.instance.ref().child("Colleges").child(collegeName).getDownloadURL();
    return url;
  }

  getImageFromCamera() async {
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

  setInitialValues () {
    url = snapshot.get("URL");
    collegeNameController.text = snapshot.get("College Name");
    starRatingDropdown = snapshot.get("Ratings");
    affiliationNoController.text = snapshot.get("Affiliation No");
    addressController.text = snapshot.get("Address");
    districtDropdown = snapshot.get("District");
    emailController.text = snapshot.get("Email");
    contact1Controller.text = snapshot.get("Contact # 1");
    contact2Controller.text = snapshot.get("Contact # 2");
    locationController.text = snapshot.get("Location");
    collegeTypeDropdown = snapshot.get("College Type");
  }

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
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
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Data.primaryColor,
                    ),
                    margin: EdgeInsets.only(top: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: _image == null?Container(color: Data.primaryColor, child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),):Image.file(
                        _image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  autofocus: false,
                  validator: (String collegeName) {
                    if (collegeName.isEmpty || collegeName == null) {
                      return "College Name can't be empty!";
                    }
                    return null;
                  },
                  controller: collegeNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "College Name:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.school,
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
                          Icons.star_rate,
                          color: Data.primaryColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 13.0,left: 10.0),
                        child: Text(
                          "Rating:",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                        child: DropdownButton<String>(
                          value: starRatingDropdown,
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
                              starRatingDropdown = newValue;
                              print(starRatingDropdown);
                              print(newValue);
                            });
                          },
                          items: <String>[
                            '\u2605 \u2605 \u2605 \u2605 \u2605',
                            '\u2605 \u2605 \u2605 \u2605',
                            '\u2605 \u2605 \u2605',
                            '\u2605 \u2605',
                            '\u2605',
                          ]
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
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  autofocus: false,
                  enabled: false,
                  validator: (String affiliation) {
                    if (affiliation.isEmpty || affiliation == null) {
                      return "Please Enter Affiliation Number!";
                    }
                    return null;
                  },
                  controller: affiliationNoController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Affiliation No:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.attribution_sharp,
                      color: Data.primaryColor,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  minLines: 3,
                  maxLines: 4,
                  autofocus: false,
                  validator: (String address) {
                    if (address.isEmpty || address == null) {
                      return "Please Enter Address!";
                    }
                    return null;
                  },
                  controller: addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                    labelText: "Address:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    prefixIcon: Icon(
                      EvaIcons.navigation,
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
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
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
                  decoration: InputDecoration(
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
                  validator: (String contact1) {
                    if (contact1.isEmpty || contact1 == null) {
                      return "Contacts can't be empty!";
                    }
                    else if (contact1.length < 10) {
                      return "Please enter a valid contact number!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                  controller: contact1Controller,
                  decoration: InputDecoration(
                    labelText: "Contact 1:",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.phone,
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
                  validator: (String contact2) {
                    if (contact2.isEmpty || contact2 == null) {
                      return "Contacts can't be empty!";
                    }
                    else if(contact2.length < 10) {
                      return "Please enter a valid contact number!";
                    }
                    return null;
                  },
                  controller: contact2Controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Data.primaryColor,
                    ),
                    labelText: "Contact 2:",
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
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 10.0),
                child: TextFormField(
                  autofocus: false,
                  validator: (String location) {
                    if (location.isEmpty || location == null) {
                      return "Location can't be empty!";
                    }
                    return null;
                  },
                  controller: locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[250],
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Data.primaryColor,
                    ),
                    labelText: "Location:",
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
                margin: EdgeInsets.only(left: 15.0,right: 15.0,bottom: 10.0),
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
                          Icons.apartment_outlined,
                          color: Data.primaryColor,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 13.0,left: 10.0),
                        child: Text(
                          "College Type:",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                        child: DropdownButton<String>(
                          value: collegeTypeDropdown,
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
                              collegeTypeDropdown = newValue;
                              print(collegeTypeDropdown);
                              print(newValue);
                            });
                          },
                          items: <String>[
                            'Wafy',
                            'Wafiyya',
                            'Wafiyya Day',
                          ]
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
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                    if(_formKey.currentState.validate()) {
                      String rating = starRatingDropdown;
                      String affiliation = affiliationNoController.text;
                      String address = addressController.text;
                      String district = districtDropdown;
                      String email = emailController.text;
                      String contact1 = contact1Controller.text;
                      String contact2 = contact2Controller.text;
                      String location = locationController.text;
                      String collegeType = collegeTypeDropdown;
                      _updateData(rating, affiliation, address, district, email, contact1, contact2, location, collegeType);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
