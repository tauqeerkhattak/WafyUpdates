import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';

class ViewEMagazines extends StatelessWidget {
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
        body: ViewEMagazineBody(),
      ),
    );
  }
}

class ViewEMagazineBody extends StatefulWidget {
  @override
  _ViewEMagazineBodyState createState() => _ViewEMagazineBodyState();
}

class _ViewEMagazineBodyState extends State<ViewEMagazineBody> {
  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((doc) =>
        Card(
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
