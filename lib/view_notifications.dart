import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wafy_updates/single_notification.dart';
import 'data.dart';

class ViewNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifications",
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
                text: "CIC",
              ),
              Tab(
                text: "WSF",
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
        body: ViewNotificationsBody(),
      ),
    );
  }
}

class ViewNotificationsBody extends StatefulWidget {
  @override
  _ViewNotificationsBodyState createState() => _ViewNotificationsBodyState();
}

class _ViewNotificationsBodyState extends State<ViewNotificationsBody> {

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((doc) =>
        Card(
          margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    QueryDocumentSnapshot snapshot = doc;
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return SingleNotification(snapshot);
                        }
                    ));
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
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                        child: Text(
                          doc.get("Description"),
                          maxLines: 3,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                        child: Text(
                          doc.get("Date"),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
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
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Notifications").where('Category', isEqualTo: 'CIC').orderBy("Time",descending: true).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return new Text("END");
              }
              return new ListView(
                children: getExpenseItems(snapshot)
              );
            },
          ),
        ),
        SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Notifications").where('Category', isEqualTo: 'WSF').orderBy("Time",descending: true).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData) {
                return new Text("END");
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
