import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wafy_updates/single_image.dart';
import 'data.dart';

class Gallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GalleryBody();
  }
}

class GalleryBody extends StatefulWidget {
  @override
  _GalleryBodyState createState() => _GalleryBodyState();
}

class _GalleryBodyState extends State<GalleryBody> {

  final picker = ImagePicker();
  var instance = FirebaseStorage.instance;
  List<String> images = [];
  bool deletedOrNot = false;

  getAllImages () async {
    List<String> tempImages = [];
    final sliderImageNameCollection = await FirebaseFirestore.instance.collection("Gallery").orderBy("Epoch", descending: true).get();
    var listOfNames = sliderImageNameCollection.docs;
    int size = sliderImageNameCollection.size;
    print("Size: $size");
    for (int i = 0;i < size;i++) {
      DocumentSnapshot eachImageDocument = listOfNames[i];
      print(eachImageDocument.get("Name"));
      String name = eachImageDocument.get("Name");
      final ref = instance.ref().child("Gallery").child("$name");
      String sliderImageUrl = await ref.getDownloadURL();
      tempImages.add(sliderImageUrl);
      print("Counter: $i");
      setState(() {
        images = tempImages;
      });
    }
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
    User user = FirebaseAuth.instance.currentUser;
    var randomNumberGenerator = Random();
    int randomNumber = randomNumberGenerator.nextInt(100000);
    String imageName = "$randomNumber${user.uid}";
    StorageReference reference = FirebaseStorage.instance.ref().child("Gallery").child(imageName);
    StorageUploadTask uploadTask = reference.putFile(uploadImage);
    await uploadTask.onComplete;
    int epoch = DateTime.now().millisecondsSinceEpoch;
    String downloadLink = await instance.ref().child("Gallery").child(imageName).getDownloadURL();
    FirebaseFirestore.instance.collection("Gallery").doc(imageName).set(
        {
          "Name": imageName,
          "Epoch": epoch,
          "Download": downloadLink,
        }
    ).then((value) => {
      print("Collection Updated with Number: $imageName"),
      FirebaseFirestore.instance.collection("Likes").doc(imageName).set({
        'postID':imageName,
        'likedBy':[],
      }),
      getAllImages(),
    });
    print("File Uploaded");
  }

  @override
  void initState() {
    getAllImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gallery",
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
        backgroundColor: Data.primaryColor,
      ),
      body: SafeArea(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          children: List.generate(images.length, (index) {
            return InkWell(
              onTap: () async {
                deletedOrNot = await Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SingleImageBody(images,index);
                  },
                ));
                if (deletedOrNot == true || deletedOrNot == null) {
                  getAllImages();
                }
              },
              child: Container(
                margin: EdgeInsets.all(1.0),
                child: images.isEmpty?Container(color: Data.primaryColor,):CachedNetworkImage(
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
