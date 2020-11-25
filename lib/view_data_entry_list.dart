import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:wafy_updates/single_data_entry.dart';
import 'data.dart';
import 'edit_data_entry.dart';

class ViewDataEntryList extends StatelessWidget {

  String fieldValue;

  ViewDataEntryList(String fieldValue) {
    this.fieldValue = fieldValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'View Data Entries',
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
      body: ViewDataEntryListBody(fieldValue),
    );
  }
}

class ViewDataEntryListBody extends StatefulWidget {

  String fieldValue;

  ViewDataEntryListBody(String fieldValue) {
    this.fieldValue = fieldValue;
  }

  @override
  _ViewDataEntryListBodyState createState() => _ViewDataEntryListBodyState(fieldValue);
}

class _ViewDataEntryListBodyState extends State<ViewDataEntryListBody> {

  String fieldValue;

  _ViewDataEntryListBodyState(String fieldValue) {
    this.fieldValue = fieldValue;
  }

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
              color: Colors.red,
              onTap: (CompletionHandler handler) async {
                await handler(false);
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmation"),
                        content: Text("Are you sure you want to delete this College entry?"),
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
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              color: Data.primaryColor,
              onTap: (CompletionHandler handler) async {
                await handler(false);
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return EditDataEntry(doc);
                    }
                ));
              }
            ),
          ],
          child: Card(
            margin: EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0,bottom: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SingleDataEntry(doc);
                      }
                  ));
                },
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            '${doc.get("Student Name")}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            'CIC No: ${doc.get("CIC")}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: (Data.orbitValues.contains(fieldValue))?FirebaseFirestore.instance.collection('Data Entry').where('Orbit',isEqualTo: fieldValue).snapshots():FirebaseFirestore.instance.collection('Data Entry').where('College Name',isEqualTo: fieldValue).snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) {
            return new Text("END");
          }
          return new ListView(
            children: getExpenseItems(snapshot),
          );
        },
      ),
    );
  }
}
