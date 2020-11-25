import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data.dart';

class DataEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orbit Entry',
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
      body: DataEntryBody(),
    );
  }
}

class DataEntryBody extends StatefulWidget {
  @override
  _DataEntryBodyState createState() => _DataEntryBodyState();
}

class _DataEntryBodyState extends State<DataEntryBody> {

  TextEditingController cicController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  String collegeDropdown = Data.collegeValues[0];
  String districtDropdown = Data.districtValues[0];
  String orbitDropdown = Data.districtValues[0];
  String orbitToBeUploaded = "";
  final _formKey = GlobalKey<FormState>();
  FocusNode focus;

  @override
  void initState() {
    focus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    cicController.dispose();
    studentNameController.dispose();
    batchController.dispose();
    mobileController.dispose();
    homeController.dispose();
    focus.dispose();
    super.dispose();
  }

  List <String> alappuzha = ['Ambalappuzha','Karthikappally'];
  List <String> ernakulam = ['Aluva','Kunnathunad','Kothamangalam','Kanayannur'];
  List <String> kannur = ['Kannur','Dharmadam','Irikkur','Kalliasseri','Mattannur','Payyannur','Peeravoor','Kuthuparamba','Taliparamba North','Taliparamba South'];
  List <String> karnataka = ['Karnataka','Dakshina Kannada'];
  List <String> kasaragod = ['Uppala','Kumbla','Cheruvathur','Thrikaripur','Uduma','Kasaragod','Mulleria','Kanhangad'];
  List <String> kollam = ['Kottarakkara','Karunagappally'];
  List <String> kozhikode = ['Kozhikode','Naduvannur','Beypore','Kunnamangalam','Thiruvambadi','Quilandy','Koduvally','Thamarassery', 'Vadakara','Nadapuram','Kuttiadi','Vanimel','Mavoor'];
  List <String> malappuram = ['Kuzhimanna','Areacode','Kavanoor','Urangattiri','Konodotty','Cheacode','Vazhakkad','Pulikkal','Muthvallur','Edayoor','Kottakkal','Kuttippuram','Marakkara','Valanchery','Anakkayam','Malappuram','Morayur','Pookkottur','Pulpatta','Keezhattur','Manjeri','Pandikkad','Parappanangadi','Tirurangadi','Thennala','Perumanna Clari','Angadippuram','Koottilangadi','Kuruva','Puzhakkattiri','Makkaraparamba','Moorkkanad','Karulai','Edakkara','Moothedam','Aliparamba','Elamkulam','Melattur','Pulamanthole','Thazhekode','PerinThalmanna','Changaramkulam','Ponnani','Vailathur','Thanalur','Thavanur','Purathur','Vattamkulam','Athavanad','Thirunavaya','Tirur','Kalpakancheri','Chelambra','Chelari','Pallikkal','Moonniyur','Vengara','Urakam','Othukkungal','Abdu Rahima Nagar','Chokkad','Kalikavu','Karuvarakundu','Mambad','Porur','Thuvur','Triprangode','Wandoor'];
  List <String> palakkad = ['Allanallur','Kottoppadam','Mannarkad','Koppam','Thiruvegapura','Pattambi','Vallapuzha','Nellaya','Cherpulacherry','Thachanattukara','Ottappalam','Palakkad','Kongad','Parudur','Thrithala'];
  List <String> thiruvananthapuram = ['Thiruvananthapuram','Nedumangad'];
  List <String> thrissur = ['Guruvayoor','Chelakkara','Kunnamkulam','Kaipamangalam','Thrissur','Kodungallur'];
  List <String> wayanad = ['Padinharethara','Sulthanbathery','Vellamunda','Mananthavady','Kalpetta'];
  List <String> pathanamthitta = ['Pathanamthitta'];
  List <String> kottayam = ['Kottayam'];
  List <String> idukki = ['Idukki'];
  List <String> tamilNadu = ['The Nilgiris'];

  String getCurrentOrbitValue (String district) {
    if (district == 'Thiruvananthapuram') {
      return thiruvananthapuram[0];
    }
    else if (district == 'Kollam') {
      return kollam[0];
    }
    else if (district == 'Alappuzha') {
      return alappuzha[0].toString();
    }
    else if (district == 'Pathanamthitta') {
      return pathanamthitta[0];
    }
    else if (district == 'Kottayam') {
      return kottayam[0];
    }
    else if (district == 'Idukki') {
      return idukki[0];
    }
    else if (district == 'Ernakulam') {
      return ernakulam[0];
    }
    else if (district == 'Thrissur') {
      return thrissur[0];
    }
    else if (district == 'Palakkad') {
      return palakkad[0];
    }
    else if (district == 'Malappuram') {
      return malappuram[0];
    }
    else if (district == 'Kozhikode') {
      return kozhikode[0];
    }
    else if (district == 'Wayanad') {
      return wayanad[0];
    }
    else if (district == 'Kannur') {
      return kannur[0];
    }
    else if (district == 'Kasaragod') {
      return kasaragod[0];
    }
    else if (district == 'Tamil Nadu') {
      return tamilNadu[0];
    }
    else if (district == 'Karnataka') {
      return karnataka[0];
    }
    return null;
  }

  getOrbitValues (String district) {
    if (district == 'Alappuzha') {
      orbitDropdown = alappuzha[0];
      return alappuzha;
    }
    else if (district == 'Ernakulam') {
      orbitDropdown = ernakulam[0];
      return ernakulam;
    }
    else if (district == 'Idukki') {
      orbitDropdown = idukki[0];
      return idukki;
    }
    else if (district == 'Kannur') {
      orbitDropdown = kannur[0];
      return kannur;
    }
    else if (district == 'Karnataka') {
      orbitDropdown = karnataka[0];
      return karnataka;
    }
    else if (district == 'Kasaragod') {
      orbitDropdown = kasaragod[0];
      return kasaragod;
    }
    else if (district == 'Kollam') {
      orbitDropdown = kollam[0];
      return kollam;
    }
    else if (district == 'Kottayam') {
      orbitDropdown = kottayam[0];
      return kottayam;
    }
    else if (district == 'Kozhikode') {
      orbitDropdown = kozhikode[0];
      return kozhikode;
    }
    else if (district == 'Malappuram') {
      orbitDropdown = malappuram[0];
      return malappuram;
    }
    else if (district == 'Palakkad') {
      orbitDropdown = palakkad[0];
      return palakkad;
    }
    else if (district == 'Pathanamthitta') {
      orbitDropdown = pathanamthitta[0];
      return pathanamthitta;
    }
    else if (district == 'Tamil Nadu') {
      orbitDropdown = tamilNadu[0];
      return tamilNadu;
    }
    else if (district == 'Thiruvananthapuram') {
      orbitDropdown = thiruvananthapuram[0];
      return thiruvananthapuram;
    }
    else if (district == 'Thrissur') {
      orbitDropdown = thrissur[0];
      return thrissur;
    }
    else if (district == 'Wayanad') {
      orbitDropdown = wayanad[0];
      return wayanad;
    }
  }

  void _addDataToFirebase (String cic,String studentName,String batch,String collegeName,String mobile,String home,String district,String orbit) {
    FirebaseFirestore.instance.collection("Data Entry").doc(cic).set({
      'CIC': cic,
      'Student Name': studentName,
      'Batch': batch,
      'College Name': collegeName,
      'Mobile': mobile,
      'Home': home,
      'District': district,
      'Orbit': orbit,
    }).then((value) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success!"),
            content: Text('Data entered successful.'),
            actions: [
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: Data.primaryColor,
                  ),
                ),
                onPressed: () {
                  homeController.text = '';
                  mobileController.text = '';
                  batchController.text = '';
                  studentNameController.text = '';
                  cicController.text = '';
                  focus.requestFocus();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  autofocus: false,
                  focusNode: focus,
                  validator: (String cic) {
                    if (cic.isEmpty || cic == null) {
                      return "CIC Number can't be empty!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
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
                  validator: (String name) {
                    if (name.isEmpty || name == null) {
                      return "Student name can't be empty!";
                    }
                    return null;
                  },
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
                  validator: (String batch) {
                    if (batch.isEmpty || batch == null) {
                      return "Batch can't be empty!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
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
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  validator: (String mobile) {
                    if (mobile.isEmpty || mobile == null) {
                      return "Mobile Number can't be empty!";
                    }
                    else if (mobile.length < 10) {
                      return "Mobile Number can't be less than 10 digits!";
                    }
                    return null;
                  },
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
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  validator: (String home) {
                    if (home.isEmpty || home == null) {
                      return "Home Number can't be empty!";
                    }
                    else if (home.length < 10) {
                      return "Home Number can't be less than 10 digits!";
                    }
                    return null;
                  },
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
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(0.0),
                              margin: EdgeInsets.only(top: 10.0,right: 0.0, left: 7.0),
                              child: Icon(
                                Icons.location_city,
                                color: Data.primaryColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0,left: 10.0, bottom: 9),
                              child: Text(
                                "District:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
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
                                orbitToBeUploaded = orbitDropdown = getCurrentOrbitValue(districtDropdown);
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
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 10.0),
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
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(0.0),
                              margin: EdgeInsets.only(top: 10.0,right: 0.0, left: 7.0),
                              child: Icon(
                                Icons.assignment_ind_outlined,
                                color: Data.primaryColor,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10.0,left: 10.0, bottom: 9),
                              child: Text(
                                "Orbit:",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                          child: DropdownButton<String>(
                              value: orbitDropdown,
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
                                  orbitToBeUploaded = orbitDropdown = newValue;
                                  print(orbitDropdown);
                                  print(newValue);
                                });
                              },
                              items: getOrbitValues(districtDropdown)
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 45,
                margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: RaisedButton(
                  child: Text("Submit"),
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
                      String cic = cicController.text;
                      String studentName = studentNameController.text;
                      String batch = batchController.text;
                      String college = collegeDropdown;
                      String mobile = mobileController.text;
                      String home = homeController.text;
                      String district = districtDropdown;
                      _addDataToFirebase(cic, studentName, batch, college, mobile, home, district, orbitToBeUploaded);
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
