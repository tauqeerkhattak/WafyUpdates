import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';
import 'edit_profile.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {

  CollectionReference reference = FirebaseFirestore.instance.collection("Registered Users");
  var storageInstance = FirebaseStorage.instance;
  User firebaseUser = FirebaseAuth.instance.currentUser;
  String url;
  TextEditingController nameController = TextEditingController();
  TextEditingController name1Controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController houseNameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController date2Controller = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController cicController = TextEditingController();
  TextEditingController collegeNameController = TextEditingController();
  TextEditingController cicBatchController = TextEditingController();

  void getImage () async {
    String uid = firebaseUser.uid;
    final ref = storageInstance.ref().child(uid);
    url =  await ref.getDownloadURL();
    setState(() {
      print(url);
    });
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    name1Controller.dispose();
    houseNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    dateController.dispose();
    bloodGroupController.dispose();
    placeController.dispose();
    districtController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    cicController.dispose();
    collegeNameController.dispose();
    cicBatchController.dispose();
    super.dispose();
  }

  Widget accountDetails () {
    DocumentReference documentReference = reference.doc(firebaseUser.email);
    documentReference.get().then((value) {
      nameController.text = value.get("Name");
      print(emailController.text);
      emailController.text = value.get("Email");
    }).catchError((onError) {
      print(onError.toString());
    });
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              enableInteractiveSelection: false,
              controller: name1Controller,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                icon: Icon(
                  Icons.perm_identity,
                  color: Data.primaryColor,
                ),
                labelText: "Name:",
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              String email = emailController.text;
              launch('mailto:$email');
            },
            child: IgnorePointer(
              child: Container(
                margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
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
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    focusColor: Data.primaryColor,
                    labelText: "Email:",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget personalDetails () {
    DocumentReference documentReference = reference.doc(firebaseUser.email);
    documentReference.get().then((value) {
      if (value != null) {
        name1Controller.text = value.get("Name");
        houseNameController.text = value.get("House Name");
        fatherNameController.text = value.get("Father Name");
        motherNameController.text = value.get("Mother Name");
        dateController.text = value.get("Date of Birth");
        placeController.text = value.get("Place");
        districtController.text = value.get("District");
        bloodGroupController.text = value.get("Blood Group");
        phoneController.text = value.get("Phone Number");
        whatsappController.text = value.get("Whatsapp Number");
      }
    });
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: name1Controller,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "Name:",
                border: InputBorder.none,
                icon: Icon(
                  Icons.perm_identity,
                  color: Data.primaryColor,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: houseNameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "House name:",
                border: InputBorder.none,
                icon: Icon(
                  Icons.home,
                  color: Data.primaryColor,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: fatherNameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "Father name:",
                icon: Icon(
                  LineAwesomeIcons.male,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: motherNameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "Mother name:",
                icon: Icon(
                  LineAwesomeIcons.female,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: dateController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "Date of Birth:",
                icon: Icon(
                  Icons.cake,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: placeController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "Place:",
                icon: Icon(
                  Icons.place,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: districtController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "District:",
                icon: Icon(
                  Icons.location_city,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: bloodGroupController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "Blood Group:",
                icon: Icon(
                  Icons.blur_on,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              String phone = phoneController.text;
              launch('tel://$phone');
            },
            child: IgnorePointer(
              child: Container(
                margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  readOnly: true,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    focusColor: Data.primaryColor,
                    labelText: "Phone:",
                    icon: Icon(
                      Icons.phone,
                      color: Data.primaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              String whatsapp = whatsappController.text;
              launch('whatsapp://send?phone=$whatsapp');
            },
            child: IgnorePointer(
              child: Container(
                margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  readOnly: true,
                  controller: whatsappController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: Data.primaryColor,
                    ),
                    focusColor: Data.primaryColor,
                    labelText: "Whatsapp:",
                    icon: Icon(
                      Icons.public,
                      color: Data.primaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget collegeDetails () {
    DocumentReference documentReference = reference.doc(firebaseUser.email);
    documentReference.get().then((value) {
      if (value != null) {
        cicController.text = value.get("CIC No");
        collegeNameController.text = value.get("College Name");
        cicBatchController.text = value.get("CIC Batch");
      }
    });
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: cicController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "CIC Number:",
                icon: Icon(
                  Icons.receipt,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: collegeNameController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "College:",
                icon: Icon(
                  Icons.school,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
           ),
          Container(
            margin: EdgeInsets.only(top: 5.0,left: 15.0,right: 15.0,bottom: 0.0),
            child: TextFormField(
              readOnly: true,
              controller: cicBatchController,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Data.primaryColor,
                ),
                focusColor: Data.primaryColor,
                labelText: "CIC Batch:",
                icon: Icon(
                  Icons.group,
                  color: Data.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.28;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Profile Page"),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Data.primaryColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return EditProfile();
            }
          )).then((value) {
            setState(() {
              getImage();
            });
          });
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Stack(
              children: <Widget>[
                Container(
                  width: Size.infinite.width,
                  height: height,
                  child: Image.asset(
                    "assets/customBackground.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: MediaQuery.of(context).size.height * 0.085,
                      child: CircleAvatar(
                       backgroundColor: Colors.white,
                        backgroundImage: url != null?CachedNetworkImageProvider(url):CachedNetworkImageProvider('https://media.tenor.com/images/67d17766117cca8152040f688609472b/tenor.gif'),
                        radius: MediaQuery.of(context).size.height * 0.08,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: Text(
                    'Account Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0,left: 10.0,right: 10.0),
                  child: accountDetails(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: Text(
                    'Personal Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0,left: 10.0,right: 10.0),
                  child: personalDetails(),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                  child: Text(
                    'College Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0,left: 10.0,right: 10.0),
                  child: collegeDetails(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}