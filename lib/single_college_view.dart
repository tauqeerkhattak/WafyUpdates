import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';

class SingleCollegeView extends StatelessWidget {

  QueryDocumentSnapshot snapshot;

  SingleCollegeView({QueryDocumentSnapshot snapshot}) {
    this.snapshot = snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "College Details",
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
      body: SingleCollegeViewBody(snapshot: snapshot),
    );
  }
}

class SingleCollegeViewBody extends StatefulWidget {

  QueryDocumentSnapshot snapshot;

  SingleCollegeViewBody ({QueryDocumentSnapshot snapshot}) {
    this.snapshot = snapshot;
  }

  @override
  _SingleCollegeViewBodyState createState() => _SingleCollegeViewBodyState(snapshot: snapshot);
}

class _SingleCollegeViewBodyState extends State<SingleCollegeViewBody> {

  TextEditingController collegeNameController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  TextEditingController affiliationNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contact1Controller = TextEditingController();
  TextEditingController contact2Controller = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController collegeTypeController = TextEditingController();
  QueryDocumentSnapshot snapshot;

  _SingleCollegeViewBodyState({QueryDocumentSnapshot snapshot}) {
    this.snapshot = snapshot;
  }

  @override
  void dispose() {
    collegeNameController.dispose();
    ratingController.dispose();
    affiliationNoController.dispose();
    addressController.dispose();
    districtController.dispose();
    emailController.dispose();
    contact1Controller.dispose();
    contact2Controller.dispose();
    locationController.dispose();
    collegeTypeController.dispose();
    super.dispose();
  }

  setTexts () {
    collegeNameController.text = snapshot.get("College Name");
    ratingController.text = snapshot.get("Ratings");
    affiliationNoController.text = snapshot.get("Affiliation No").toString();
    addressController.text = snapshot.get("Address");
    districtController.text = snapshot.get("District");
    emailController.text = snapshot.get("Email");
    contact1Controller.text = snapshot.get("Contact # 1");
    contact2Controller.text = snapshot.get("Contact # 2");
    locationController.text = snapshot.get("Location");
    collegeTypeController.text = snapshot.get("College Type");
  }

  @override
  Widget build(BuildContext context) {
    setTexts();
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            margin: EdgeInsets.all(10.0),
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                snapshot.get("URL"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    minLines: 2,
                    maxLines: 3,
                    controller: collegeNameController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.perm_identity,
                        color: Data.primaryColor,
                      ),
                      labelText: "College Name:",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: ratingController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.star_rate,
                        color: Data.primaryColor,
                      ),
                      labelText: "Ratings:",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: affiliationNoController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.attribution_sharp,
                        color: Data.primaryColor,
                      ),
                      labelText: "Affiliation No:",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: addressController,
                    decoration: InputDecoration(
                      icon: Icon(
                        EvaIcons.navigation,
                        color: Data.primaryColor,
                      ),
                      labelText: "Address:",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: districtController,
                    decoration: InputDecoration(
                      icon: Icon(
                        EvaIcons.navigation,
                        color: Data.primaryColor,
                      ),
                      labelText: "District:",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    String email = snapshot.get("Email");
                    launch('mailto:$email');
                  },
                  child: IgnorePointer(
                    child: Container(
                      margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        readOnly: true,
                        enableInteractiveSelection: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Data.primaryColor,
                          ),
                          labelText: "Email:",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    String phone = snapshot.get("Contact # 1");
                    launch('tel://$phone');
                  },
                  child: IgnorePointer(
                    child: Container(
                      margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        readOnly: true,
                        enableInteractiveSelection: false,
                        controller: contact1Controller,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Data.primaryColor,
                          ),
                          labelText: "Contact 1:",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String phone = snapshot.get("Contact # 2");
                    launch('tel://$phone');
                  },
                  child: IgnorePointer(
                    child: Container(
                      margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        readOnly: true,
                        enableInteractiveSelection: false,
                        controller: contact2Controller,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.phone,
                            color: Data.primaryColor,
                          ),
                          labelText: "Contact 2:",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    print("Tapped");
                    String location = snapshot.get("Location");
                    if(location.contains('https://')) {
                      if(await canLaunch(location)) {
                        print("Yes, launch");
                        launch(location);
                      }
                      else {
                        print('Could not open $location');
                      }
                    }
                    else if(location.contains('http://')){
                      if(await canLaunch(location)) {
                        await launch(location);
                      }
                      else {
                        print('Could not open $location');
                      }
                    }
                    else {
                      location = "https://$location";
                      if(await canLaunch(location)) {
                        await launch(location);
                      }
                      else {
                        print('Could not open $location');
                      }
                    }
                  },
                  child: IgnorePointer(
                    child: Container(
                      margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                        readOnly: true,
                        enableInteractiveSelection: false,
                        controller: locationController,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.location_on,
                            color: Data.primaryColor,
                          ),
                          labelText: "Location:",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    readOnly: true,
                    enableInteractiveSelection: false,
                    controller: collegeTypeController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.apartment_outlined,
                        color: Data.primaryColor,
                      ),
                      labelText: "College Type:",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
