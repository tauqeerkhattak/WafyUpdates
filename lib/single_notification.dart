import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data.dart';

// ignore: must_be_immutable
class SingleNotification extends StatelessWidget {

  QueryDocumentSnapshot snapshot;

  SingleNotification(QueryDocumentSnapshot snapshot) {
    this.snapshot = snapshot;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "View Notification",
          style: TextStyle(
            color: Colors.white
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
      body: SafeArea(
        child: Card(
          shadowColor: Colors.black,
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      snapshot.get("Date"),
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                        snapshot.get("Title"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            "Category: ${snapshot.get("Category")}",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            snapshot.get("Description"),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}