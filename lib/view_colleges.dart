import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wafy_updates/single_college_view.dart';
import 'data.dart';

class ViewColleges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "View Colleges",
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
                text: "Wafy",
              ),
              Tab(
                text: "Waffiya",
              ),
              Tab(
                text: "Waffiya Day",
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
        body: ViewCollegesBody(),
      ),
    );
  }
}

class ViewCollegesBody extends StatefulWidget {
  @override
  _ViewCollegesBodyState createState() => _ViewCollegesBodyState();
}

class _ViewCollegesBodyState extends State<ViewCollegesBody> {

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((doc) =>
        Card(
          margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0,bottom: 5.0),
          child: Container(
            padding: EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SingleCollegeView(snapshot: doc,);
                    }
                ));
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red,
                      backgroundImage: NetworkImage(
                        doc.get("URL"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:10,right: 10,left: 10),
                          child: Text(
                            doc.get("College Name"),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Text(
                            'Affiliation No: ${doc.get("Affiliation No")}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: Text(
                            'Rating: ${doc.get('Ratings')}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("Colleges").where('College Type', isEqualTo: 'Wafy').orderBy('Affiliation No').snapshots(),
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
            stream: FirebaseFirestore.instance.collection("Colleges").where('College Type', isEqualTo: 'Wafiyya').orderBy('Affiliation No').snapshots(),
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
            stream: FirebaseFirestore.instance.collection("Colleges").where('College Type', isEqualTo: 'Wafiyya Day').orderBy('Affiliation No').snapshots(),
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
