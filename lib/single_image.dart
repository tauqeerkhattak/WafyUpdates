import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:http/http.dart' as http;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share/share.dart';

import 'data.dart';

class SingleImageBody extends StatefulWidget {

  List <String> images;
  int index;

  SingleImageBody(List <String> images,int index) {
    this.images = images;
    this.index = index;
  }

  @override
  _SingleImageBodyState createState() => _SingleImageBodyState(images,index);
}

class _SingleImageBodyState extends State<SingleImageBody> {

  List <String> images;
  int index;
  bool imageDeleted = false;

  _SingleImageBodyState(List <String> images,int index) {
    this.images = images;
    this.index = index;
  }

  Future<bool> compareDownloadURL (String url) async {
    var galleryCollectionReference = await FirebaseFirestore.instance.collection("Gallery").get();
    var listOfDocuments = galleryCollectionReference.docs;
    int size = listOfDocuments.length;
    for (int i = 0;i < size;i++) {
      DocumentSnapshot eachDocument = listOfDocuments[i];
      String downloadURL = eachDocument.get("Download").toString();
      if(downloadURL == url) {
        return true;
      }
    }
  }

  Future<int> getNumberOfLikes (String postID) async {
    Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance.collection("Likes").doc(postID).get();
    DocumentSnapshot doc = await docSnapshot;
    List list = doc.get("likedBy");
    return list.length;
  }

  Future <DocumentSnapshot> getLikeStatus (String postID) async {
    Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance.collection('Likes').doc(postID).get();
    DocumentSnapshot doc = await docSnapshot;
    return doc;
  }

  Future<DocumentSnapshot> getSpecificImageDocument (String url) async {
    var galleryCollectionReference = await FirebaseFirestore.instance.collection("Gallery").get();
    var listOfDocuments = galleryCollectionReference.docs;
    int size = listOfDocuments.length;
    for (int i = 0;i < size;i++) {
      DocumentSnapshot eachDocument = listOfDocuments[i];
      String downloadURL = eachDocument.get("Download");
      if(downloadURL == url) {
        return eachDocument;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.40;
    double width = MediaQuery.of(context).size.width;
    ItemScrollController controller = ItemScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Image View",
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
            Navigator.pop(context, imageDeleted);
          },
        ),
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: controller,
        initialScrollIndex: this.index,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return SwipeActionCell(
            key: ObjectKey(images),
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
                          content: Text("Are you sure you want to delete this image?"),
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
                              onTap: () async {
                                DocumentSnapshot doc = await getSpecificImageDocument(images[index]);
                                String imageName = doc.get('Name');
                                doc.reference.delete().then((value) {
                                  imageDeleted = true;
                                  FirebaseFirestore.instance.collection('Likes').doc(imageName).delete();
                                  FirebaseStorage.instance.ref().child('Gallery').child(imageName).delete();
                                });
                                setState(() {
                                  images.removeAt(index);
                                });
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
              ),
            ],
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Data.primaryColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          imageUrl: images[index],
                          height: height,
                          width: width,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                child: FutureBuilder(
                                  future: getSpecificImageDocument(images[index]),
                                  builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      return FutureBuilder(
                                        future: getLikeStatus(snapshot.data.get('Name')),
                                        builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot) {
                                          if(snapshot.hasData) {
                                            List <String> list = List.castFrom(snapshot.data.get('likedBy'));
                                            String userUID = FirebaseAuth.instance.currentUser.uid;
                                            print('People who liked this: $list');
                                            print('PostID: ${snapshot.data.get('postID')}');
                                            if(!list.contains(userUID)) {
                                              return Container(
                                                margin: EdgeInsets.only(left: 5),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (await compareDownloadURL(images[index])) {
                                                      List <String> list = [FirebaseAuth.instance.currentUser.uid];
                                                      DocumentSnapshot snapshot = await getSpecificImageDocument(images[index]);
                                                      FirebaseFirestore.instance.collection("Likes").doc(snapshot.get("Name")).update({
                                                        'likedBy': FieldValue.arrayUnion(list),
                                                      }).then((value) async {
                                                        print("Liked post: ${snapshot.get("Name")}");
                                                      });
                                                      setState(() {

                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    EvaIcons.heartOutline,
                                                    color: Colors.red,
                                                    size: 27,
                                                  ),
                                                ),
                                              );
                                            }
                                            else if(list.contains(userUID)){
                                              return Container(
                                                margin: EdgeInsets.only(left: 5),
                                                child: InkWell(
                                                  onTap: () async {
                                                    if (await compareDownloadURL(images[index])) {
                                                      List <String> list = [FirebaseAuth.instance.currentUser.uid];
                                                      DocumentSnapshot snapshot = await getSpecificImageDocument(images[index]);
                                                      FirebaseFirestore.instance.collection("Likes").doc(snapshot.get("Name")).update({
                                                        'likedBy': FieldValue.arrayRemove(list),
                                                      }).then((value) async {
                                                        print("Liked removed: ${snapshot.get("Name")}");
                                                      });
                                                      setState(() {

                                                      });
                                                    }
                                                  },
                                                  child: Icon(
                                                    EvaIcons.heart,
                                                    color: Colors.red,
                                                    size: 27,
                                                  ),
                                                ),
                                              );
                                            }
                                            else {
                                              return CircularProgressIndicator();
                                            }
                                          }
                                          else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      );
                                    }
                                    else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                              Container(
                                child: FutureBuilder(
                                  future: getSpecificImageDocument(images[index]),
                                  builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot) {
                                    if(snapshot.hasData) {
                                      return FutureBuilder(
                                        future: getNumberOfLikes(snapshot.data.get("Name")),
                                        builder: (BuildContext context, AsyncSnapshot <int> snapshot) {
                                          if (snapshot.hasData) {
                                            return Container(
                                              margin: EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                "${snapshot.data} Likes",
                                                style: TextStyle(
                                                  color: Data.primaryColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            );
                                          }
                                          else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      );
                                    }
                                    else {
                                      return CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    EvaIcons.download,
                                    color: Data.primaryColor,
                                    size: 27,
                                  ),
                                  onPressed: () {
                                    String path = '${images[index]}.jpg';
                                    print(path);
                                    GallerySaver.saveImage(path,albumName: "Wafy Feeds").whenComplete(() {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Success!"),
                                              content: Text("Picture saved in your gallery in Wafy Feeds folder."),
                                              actions: <Widget>[
                                                RaisedButton(
                                                  child: Text("OK"),
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
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                      );
                                      print("Image Saved!");
                                    });
                                  },
                                ),
                              ),
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    EvaIcons.share,
                                    color: Data.primaryColor,
                                    size: 27,
                                  ),
                                  onPressed: () async {
                                    var range = new Random();
                                    Directory tempDir = await getTemporaryDirectory();
                                    String tempPath = tempDir.path;
                                    File file = new File('$tempPath'+range.nextInt(100).toString()+'.png');
                                    http.Response response = await http.get(images[index]);
                                    await file.writeAsBytes(response.bodyBytes);
                                    Share.shareFiles(['${file.path}'],text: 'Image shared from Wafy Feeds app');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
