import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:wafy_updates/add_emagazine.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';

class AdminViewEMagazines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "View E-Read",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Tab(
                text: "Newspaper",
              ),
              Tab(
                text: "Kithab",
              ),
              Tab(
                text: "Library Books",
              ),
            ],
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
          backgroundColor: Data.primaryColor,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Data.primaryColor,
          child: Icon(
            EvaIcons.book,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddEMagazine();
                }
            ));
          },
        ),
        body: AdminViewEMagazineBody(),
      ),
    );
  }
}

class AdminViewEMagazineBody extends StatefulWidget {
  @override
  _AdminViewEMagazineBodyState createState() => _AdminViewEMagazineBodyState();
}

class _AdminViewEMagazineBodyState extends State<AdminViewEMagazineBody> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _urlController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((doc) =>
        SwipeActionCell(
          key: ObjectKey(doc),
          performsFirstActionWithFullSwipe: true,
          trailingActions: [
            SwipeAction(
              paddingToBoundary: 10,
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onTap: (CompletionHandler handler) async {
                await handler(false);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Are you sure you want to delete \"${doc.get("Title")}\"?"),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Data.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Data.primaryColor,
                                ),
                              ),
                              onPressed: () {
                                doc.reference.delete();
                                Navigator.pop(context);
                              }
                          ),
                        ],
                      );
                    }
                );
              },
            ),
            SwipeAction(
              paddingToBoundary: 10,
              widthSpace: 120,
              color: Data.primaryColor,
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onTap: (CompletionHandler handler) async {
                _titleController.text = doc.get("Title");
                _urlController.text = doc.get("URL");
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Form(
                        key: _formKey,
                        child: AlertDialog(
                          title: Container(
                            child: TextFormField(
                              validator: (String title) {
                                if (title.isEmpty || title == null) {
                                  return "Title can't be empty!";
                                }
                                return null;
                              },
                              controller: _titleController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[250],
                                labelText: "Title:",
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
                          content: Container(
                            child: TextFormField(
                              minLines: 5,
                              maxLines: 6,
                              validator: (String url) {
                                if (url.isEmpty || url == null) {
                                  return "URL can't be empty!";
                                }
                                else if(url.length < 20) {
                                  return "URL cant be less than 20 characters.";
                                }
                                return null;
                              },
                              controller: _urlController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[250],
                                labelText: "URL:",
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
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Data.primaryColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                                child: Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Data.primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  String title = _titleController.text;
                                  String url = _urlController.text;
                                  FirebaseFirestore.instance.collection("URL").doc(doc.id).update({
                                    "Title":title,
                                    "URL":url,
                                  }).then((value) {
                                    print("Data updated!");
                                    _titleController.text = "";
                                    _urlController.text = "";
                                  });
                                  Navigator.pop(context);
                                }
                            ),
                          ],
                        ),
                      );
                    }
                );
              },
            ),
          ],
          child: Card(
            margin: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0,bottom: 5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () async {
                      String url = doc.get('URL');
                      if(url.contains('https://')) {
                        if(await canLaunch(url)) {
                          await launch(url);
                        }
                        else {
                          print('Could not open $url');
                        }
                      }
                      else if(url.contains('http://')){
                        if(await canLaunch(url)) {
                          await launch(url);
                        }
                        else {
                          print('Could not open $url');
                        }
                      }
                      else {
                        url = "https://$url";
                        if(await canLaunch(url)) {
                          await launch(url);
                        }
                        else {
                          print('Could not open $url');
                        }
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            doc.get("Title"),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("URL").where('Category', isEqualTo: 'Newspaper').orderBy("Title",descending: false).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return new Text("");
              }
              return new ListView(
                  children: getExpenseItems(snapshot)
              );
            },
          ),
        ),
        SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("URL").where('Category', isEqualTo: 'Kithab').orderBy("Title",descending: false).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return new Text("");
              }
              return new ListView(
                children: getExpenseItems(snapshot),
              );
            },
          ),
        ),
        SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("URL").where('Category', isEqualTo: 'Library book').orderBy("Title",descending: false).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return new Text("");
              }
              return new ListView(
                children: getExpenseItems(snapshot),
              );
            },
          ),
        ),
      ],
    );
  }
}
