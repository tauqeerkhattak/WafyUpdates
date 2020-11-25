import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';

// ignore: must_be_immutable
class SingleDataEntry extends StatelessWidget {

  QueryDocumentSnapshot doc;

  SingleDataEntry(QueryDocumentSnapshot doc) {
    this.doc = doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Single Data Entry',
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
      ),
      body: SingleDataEntryBody(doc),
    );
  }
}

// ignore: must_be_immutable
class SingleDataEntryBody extends StatefulWidget {

  QueryDocumentSnapshot doc;

  SingleDataEntryBody(QueryDocumentSnapshot doc) {
    this.doc = doc;
  }

  @override
  _SingleDataEntryBodyState createState() => _SingleDataEntryBodyState(doc);
}

class _SingleDataEntryBodyState extends State<SingleDataEntryBody> {

  QueryDocumentSnapshot doc;
  TextEditingController cicController = TextEditingController();
  TextEditingController collegeName = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController orbitController = TextEditingController();

  _SingleDataEntryBodyState(QueryDocumentSnapshot doc) {
    this.doc = doc;
  }

  setValues () {
    cicController.text = doc.get('CIC');
    collegeName.text = doc.get('College Name');
    studentNameController.text = doc.get('Student Name');
    batchController.text = doc.get('Batch');
    mobileController.text = doc.get('Mobile');
    homeController.text = doc.get('Home');
    districtController.text = doc.get('District');
    orbitController.text = doc.get('Orbit');
  }

  @override
  void dispose() {
    cicController.dispose();
    collegeName.dispose();
    studentNameController.dispose();
    batchController.dispose();
    mobileController.dispose();
    homeController.dispose();
    districtController.dispose();
    orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setValues();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
              child: TextFormField(
                readOnly: true,
                autofocus: false,
                controller: cicController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250],
                  labelText: "CIC Number:",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Data.primaryColor,
                      width: 2.5,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.confirmation_num,
                    color: Data.primaryColor,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
              child: TextFormField(
                autofocus: false,
                readOnly: true,
                controller: studentNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250],
                  labelText: "Student Name:",
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
              margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
              child: TextFormField(
                autofocus: false,
                readOnly: true,
                controller: batchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250],
                  labelText: "Batch No:",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Data.primaryColor,
                      width: 2.5,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.batch_prediction,
                    color: Data.primaryColor,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
              child: TextFormField(
                autofocus: false,
                readOnly: true,
                controller: collegeName,
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
                    Icons.location_city,
                    color: Data.primaryColor,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                String mobile = mobileController.text;
                launch('tel://$mobile');
              },
              child: IgnorePointer(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    autofocus: false,
                    readOnly: true,
                    controller: mobileController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[250],
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: Data.primaryColor,
                      ),
                      labelText: "Mobile Number:",
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
              ),
            ),
            InkWell(
              onTap: () {
                String home = homeController.text;
                launch('tel://$home');
              },
              child: IgnorePointer(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: TextFormField(
                    autofocus: false,
                    readOnly: true,
                    controller: homeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[250],
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Data.primaryColor,
                      ),
                      labelText: "Home Number:",
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
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
              child: TextFormField(
                autofocus: false,
                readOnly: true,
                controller: districtController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250],
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: Data.primaryColor,
                  ),
                  labelText: "District:",
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
                readOnly: true,
                controller: orbitController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250],
                  prefixIcon: Icon(
                    Icons.assignment_ind_outlined,
                    color: Data.primaryColor,
                  ),
                  labelText: "Orbit:",
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
          ],
        ),
      ),
    );
  }
}
