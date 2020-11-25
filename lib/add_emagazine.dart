import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEMagazine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add E-Read",
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
        backgroundColor: Colors.cyan,
      ),
      body: AddEMagazineBody(),
    );
  }
}

class AddEMagazineBody extends StatefulWidget {
  @override
  _AddEMagazineBodyState createState() => _AddEMagazineBodyState();
}

class _AddEMagazineBodyState extends State<AddEMagazineBody> {
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String categoryDropdown = 'Newspaper';
  FocusNode focusNode;

  void _addEMagazineToFirebase (String title,String url,String category) {
    FirebaseFirestore.instance.collection("URL").doc(title).set({
      "Title":title,
      "URL":url,
      "Category":category,
    }).then((value) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Operation Successful!"),
              content: Text("URL successfully added!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    titleController.text = "";
                    urlController.text = "";
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
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    urlController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
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
                        color: Colors.cyan,
                      ),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: TextFormField(
                  controller: urlController,
                  validator: (String url) {
                    if(url.isEmpty || url == null) {
                      return "Please enter a URL";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.cyan,
                      ),
                    ),
                    fillColor: Colors.grey[250],
                    filled: true,
                    labelText: "URL:",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.cyan,
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
                    color: Colors.cyan,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5.0,right: 10.0),
                      child: Text(
                        "Category: ",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: DropdownButton<String>(
                          value: categoryDropdown,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.cyan,
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.cyan),
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
                          items: <String>['Newspaper', 'Kithab', 'Library book']
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
              Container(
                margin: EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0,bottom: 0.0),
                child: RaisedButton(
                  child: Text("Submit"),
                  color: Colors.cyan,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.cyan,
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
                              content: Text("Are you sure you want to add this URL to our server?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Sure"),
                                  onPressed: () {
                                    String title = titleController.text;
                                    String description = urlController.text;
                                    String category = categoryDropdown;
                                    focusNode.requestFocus();
                                    categoryDropdown = 'Newspaper';
                                    _addEMagazineToFirebase(title,description,category);
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
            ],
          ),
        ),
      ),
    );
  }
}
