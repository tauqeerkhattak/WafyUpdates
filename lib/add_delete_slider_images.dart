import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:image_picker/image_picker.dart';

class AddDeleteImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AddDeleteImageSliderBody();
  }
}

class AddDeleteImageSliderBody extends StatefulWidget {
  @override
  _AddDeleteImageSliderBodyState createState() => _AddDeleteImageSliderBodyState();
}

class _AddDeleteImageSliderBodyState extends State<AddDeleteImageSliderBody> {

  var instance = FirebaseStorage.instance;
  List<String> images = [];
  final picker = ImagePicker();

  getAllImages () async {
    List<String> tempImages = [];
    final sliderImageNameCollection = await FirebaseFirestore.instance.collection("ImageSliderNames").get();
    var listOfNames = sliderImageNameCollection.docs;
    int size = sliderImageNameCollection.size;
    print("Size: $size");
    for (int i = 0;i < size;i++) {
      DocumentSnapshot eachImageDocument = listOfNames[i];
      print(eachImageDocument.get("Name"));
      String name = eachImageDocument.get("Name");
      final ref = instance.ref().child("ImageSlider").child("$name");
      String sliderImageUrl = await ref.getDownloadURL();
      tempImages.add(sliderImageUrl);
      print("Counter: $i");
    }
    setState(() {
      images = tempImages;
    });
  }

  Future<File> getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return File(pickedFile.path);
  }

  Future <File> getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  Future uploadFile (File uploadImage) async {
    var randomNumberGenerator = Random();
    int randomNumber = randomNumberGenerator.nextInt(1000);
    String imageName = "$randomNumber";
    StorageReference reference = FirebaseStorage.instance.ref().child("ImageSlider").child(imageName);
    StorageUploadTask uploadTask = reference.putFile(uploadImage);
    await uploadTask.onComplete;
    FirebaseFirestore.instance.collection("ImageSliderNames").doc(imageName).set(
        {
          "Name": imageName,
        }
    ).then((value) => {
      print("Collection Updated with Number: $imageName"),
      getAllImages(),
    });
    print("File Uploaded");
  }

  deleteImage (int name) async {
    print(name);
    final sliderImageNameCollection = await FirebaseFirestore.instance.collection("ImageSliderNames").get();
    var listOfNames = sliderImageNameCollection.docs;
    DocumentSnapshot imageDocument = listOfNames[name];
    String imageName = imageDocument.get("Name");
    instance.ref().child("ImageSlider").child("$imageName").delete().then((value) {
      FirebaseFirestore.instance.collection("ImageSliderNames").doc(imageName).delete().then((value) {
        print("Deleted!");
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Image Deleted Successfully!"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.cyan,
                  onPressed: () {
                    getAllImages();
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
    getAllImages();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add/Delete Images",
          style: TextStyle(
            color: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Upload"),
                  content: Text("Please select a picture you would like to upload the slideshow!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.cyan,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Camera",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.cyan,
                      onPressed: () async {
                        File image = await getImageFromCamera();
                        if(image != null) {
                          uploadFile(image);
                        }
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.cyan,
                      onPressed: () async {
                        File image = await getImageFromGallery();
                        if (image != null) {
                          uploadFile(image);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }
          );
        },
      ),
      body: SafeArea(
        child: ListView(
          children: new List.generate(images.length, (int index) {
            print("Index: $index");
            return SwipeActionCell(
              key: ObjectKey(images[index]),
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
                    String item = images.elementAt(index);
                    deleteImage(images.indexOf(item));
                  },
                ),
              ],
              child: ListTile(
                title: Container(
                  margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.cyan,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        height: 200,
                        width: 1000.0,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded/loadingProgress.expectedTotalBytes: null,
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
