import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modified_flutter_app/add_notification.dart';
import 'package:modified_flutter_app/single_notification.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

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
        floatingActionButton: FloatingActionButton(
          child: Icon(
            EvaIcons.fileAdd,
            color: Colors.white,
          ),
          backgroundColor: Data.primaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return AddNotification();
              }
            ));
          },
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

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.docs.map((doc) =>
       SwipeActionCell(
         key: ObjectKey(doc),
         performsFirstActionWithFullSwipe: true,
         trailingActions: <SwipeAction> [
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
                       content: Text("Are you sure you want to delete this \"${doc.get("Title")}\" notification?"),
                       actions: <Widget>[
                         InkWell(
                             onTap:() {
                               Navigator.pop(context);
                             },
                             child: Container(
                               margin: EdgeInsets.all(15),
                               child: Text(
                                 'No',
                                 style: TextStyle(
                                   color: Data.primaryColor,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             )),
                         InkWell(
                           onTap: () {
                             doc.reference.delete();
                             Navigator.pop(context);
                           },
                           child: Container(
                             margin: EdgeInsets.only(top: 15, bottom: 15,left: 0,right:15),
                             child: Text(
                               'Yes',
                               style: TextStyle(
                                 color: Data.primaryColor,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                         ),
                       ],
                     );
                   }
               );
             },
             color: Colors.red,
           ),
           SwipeAction(
             paddingToBoundary: 10,
             widthSpace: 120.0,
             icon: Icon(
               Icons.edit,
               color: Colors.white,
             ),
             onTap: (CompletionHandler handler) async {
               await handler(false);
               print('Edit');
               _titleController.text = doc.get("Title");
               _descController.text = doc.get("Description");
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
                             validator: (String desc) {
                               if (desc.isEmpty || desc == null) {
                                 return "Description can't be empty!";
                               }
                               else if(desc.length < 20) {
                                 return "Description cant be less than 20 characters.";
                               }
                               return null;
                             },
                             controller: _descController,
                             keyboardType: TextInputType.emailAddress,
                             decoration: InputDecoration(
                               filled: true,
                               fillColor: Colors.grey[250],
                               labelText: "Description:",
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
                                 String desc = _descController.text;
                                 int time = doc.get("Time");
                                 FirebaseFirestore.instance.collection("Notifications").doc(doc.id).update({
                                   "Title":title,
                                   "Description":desc,
                                   "Time":time,
                                 }).then((value) {
                                   print("Data updated!");
                                   _titleController.text = "";
                                   _descController.text = "";
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
             color: Data.primaryColor,
           ),
         ],
         child: Card(
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
