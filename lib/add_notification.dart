import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wafy_updates/in_app_messaging.dart';
import 'data.dart';

class AddNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Add Notification",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Data.primaryColor,
      ),
      body: AddNotificationBody(),
    );
  }
}

class AddNotificationBody extends StatefulWidget {
  @override
  _AddNotificationBodyState createState() => _AddNotificationBodyState();
}

class _AddNotificationBodyState extends State<AddNotificationBody> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String categoryDropdown = 'CIC';
  FocusNode focusNode;
  InAppMessaging message = InAppMessaging();

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  void _addNotificationToFirebase (String title,String desc,String category) {
    String date = formatDate(DateTime.now(), [dd,'-',mm,'-',yyyy,' ',hh,':',nn,':',ss]);
    String date2 = formatDate(DateTime.now(), [dd,'-',mm,'-',yyyy]);
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).truncate();
    FirebaseFirestore.instance.collection("Notifications").doc(date).set({
      "Title":title,
      "Description":desc,
      "Category":category,
      "Date":date2,
      "Time":time,
    }).then((value) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Operation Successful!"),
              content: Text("Notification successfully added! Do you to want to send this as a push notification?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    titleController.text = "";
                    descController.text = "";
                    focusNode.requestFocus();
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    await message.sendNotificationMessage('New notification received!', title).whenComplete(() {
                      titleController.text = '';
                      descController.text = '';
                      focusNode.requestFocus();
                      Navigator.pop(context);
                    });
                  },
                ),
              ],
            );
          }
      );
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    message.init(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: titleController,
                  validator: (String title) {
                    if(title.isEmpty || title == null) {
                      return "Please enter a title";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey[250],
                    filled: true,
                    labelText: "Title:",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  autofocus: false,
                  controller: descController,
                  validator: (String desc) {
                    if(desc.isEmpty || desc == null) {
                      return "Please enter description";
                    }
                    else if (desc.length < 20) {
                      return "Description must be at least 20 characters.";
                    }
                    return null;
                  },
                  minLines: 8,
                  maxLines: 10,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                      ),
                    ),
                    fillColor: Colors.grey[250],
                    filled: true,
                    labelText: "Description:",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Data.primaryColor,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(
                    color: Data.primaryColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0,right: 10.0),
                        child: Text(
                          "Category: ",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Center(
                          child: DropdownButton<String>(
                            value: categoryDropdown,
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
                                categoryDropdown = newValue;
                                print(categoryDropdown);
                                print(newValue);
                              });
                            },
                            items: <String>['CIC', 'WSF']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: SizedBox(
                  height: 45,
                  child: RaisedButton(
                    child: Text("Submit"),
                    color: Data.primaryColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(
                        color: Data.primaryColor,
                        width: 2.5,
                      ),
                    ),
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmation"),
                                content: Text("Are you sure you want to add this notification?"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Sure"),
                                    onPressed: () {
                                      String title = titleController.text;
                                      String description = descController.text;
                                      String category = categoryDropdown;
                                      _addNotificationToFirebase(title,description,category);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      }
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
