import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:wafy_updates/add_delete_slider_images.dart';
import 'package:wafy_updates/push_notification.dart';
import 'package:wafy_updates/search_data_entry.dart';
import 'package:wafy_updates/single_notification.dart';
import 'package:wafy_updates/view_colleges.dart';
import 'package:wafy_updates/view_emagazine.dart';
import 'package:wafy_updates/view_notifications.dart';
import 'data.dart';
import 'gallery.dart';
import 'in_app_messaging.dart';
import 'menu_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var instance = FirebaseStorage.instance;
  var firstSnapshot;
  var snapshot;
  List<String> images = [];
  final picker = ImagePicker();
  String firstLikedImage;
  String secondLikedImage;
  String thirdLikedImage;
  String dummyImage = 'https://media.tenor.com/images/67d17766117cca8152040f688609472b/tenor.gif';
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void onRefresh () async {
    getTopLikedImages();
    initializeFirstSnapshot();
    getAllImages();
    await Future.delayed(Duration(seconds: 5));
    _refreshController.refreshCompleted();
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
    if(mounted) {
      setState(() {
        images = tempImages;
      });
    }
  }

  getTopLikedImages () async {
    final likesCollection = await FirebaseFirestore.instance.collection("Likes").get();
    var listOfLikes = likesCollection.docs;
    int size = likesCollection.size;
    int first,second,third;
    first = second = third = 0;
    String firstPost,secondPost,thirdPost;
    for (int i = 0;i < size;i++) {
      DocumentSnapshot eachDocument = await listOfLikes[i];
      List list = eachDocument.get("likedBy");
      if(list.length > first) {
        third = second;
        second = first;
        first = list.length;
        thirdPost = secondPost;
        secondPost = firstPost;
        firstPost = eachDocument.get("postID");
      }
      else if (list.length > second) {
        third = second;
        second = list.length;
        thirdPost = secondPost;
        secondPost = eachDocument.get("postID");
      }
      else if (list.length > third) {
        third = list.length;
        thirdPost = eachDocument.get("postID");
      }
    }
    print("First: $firstPost, Likes: $first");
    print("Second: $secondPost, Likes: $second");
    print("Third: $thirdPost, Likes: $third");
    var galleryCollection = await FirebaseFirestore.instance.collection("Gallery");
    var firstDoc = await galleryCollection.doc(firstPost).get();
    var secondDoc = await galleryCollection.doc(secondPost).get();
    var thirdDoc = await galleryCollection.doc(thirdPost).get();
    firstLikedImage = (first == 0)?'https://1m19tt3pztls474q6z46fnk9-wpengine.netdna-ssl.com/wp-content/themes/unbound/images/No-Image-Found-400x264.png':firstDoc.get("Download");
    secondLikedImage = (second == 0)?'https://1m19tt3pztls474q6z46fnk9-wpengine.netdna-ssl.com/wp-content/themes/unbound/images/No-Image-Found-400x264.png':secondDoc.get("Download");
    thirdLikedImage = (third == 0)?'https://1m19tt3pztls474q6z46fnk9-wpengine.netdna-ssl.com/wp-content/themes/unbound/images/No-Image-Found-400x264.png':thirdDoc.get("Download");
  }

  deleteImage (int name) async {
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
                color: Data.primaryColor,
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


  Future<QuerySnapshot> getFirstSnapshot () async {
    return await FirebaseFirestore.instance.collection("Notifications").orderBy("Time",descending: true).limit(1).snapshots().first;
  }

  Future <QueryDocumentSnapshot> getSnapshot () async {
    QuerySnapshot snapshot = await getFirstSnapshot();
    return snapshot.docs.first;
  }

  initializeFirstSnapshot () async {
    firstSnapshot = await getFirstSnapshot();
    snapshot = await getSnapshot();
  }

  @override
  dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  initState() {
    getTopLikedImages();
    initializeFirstSnapshot();
    getAllImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PushNotificationsManager manager = PushNotificationsManager();
    manager.init(context);
    InAppMessaging message = InAppMessaging();
    message.init(context);
    double height = 200;

    final List<Widget> imageSliders = images.map((item) => Container(
      margin: EdgeInsets.all(0),
      child: Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator())),
                ),
                imageUrl: item,
                fit: BoxFit.fitWidth,
                width: 1000,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  //padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    )).toList();

    List<Widget> noImageAvailableList = [
      Image.asset('assets/loading image.jpg',
      fit: BoxFit.fitWidth,),
    ];

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          drawer: MenuWidget(),
          appBar: AppBar(
            title: Text(
              Data.appName,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: Data.primaryColor,
          ),
          body: ColoredBox(
            color: Colors.grey.shade300,
            child: Container(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropMaterialHeader(
                  color: Colors.white,
                  backgroundColor: Data.primaryColor,
                ),
                controller: _refreshController,
                onRefresh: onRefresh,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5,left: 5,right: 5),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          aspectRatio: 2.0,
                          viewportFraction: 1.0,
                          enlargeCenterPage: true,
                        ),
                        items: imageSliders.isEmpty?noImageAvailableList:imageSliders,
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 5.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0)
                      ),
                      child: ListTile(
                        title: Container(
                          margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                          child: Text(
                            "New Update",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(left: 15.0,bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return SingleNotification(snapshot);
                                      }
                                  ));
                                },
                                child: Text(
                                  (firstSnapshot == null)?"Retrieving Title...":firstSnapshot.docs[0].get("Title"),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return SingleNotification(snapshot);
                                      }
                                  ));
                                },
                                child: Text(
                                  (firstSnapshot == null)?"Retrieving Description...":firstSnapshot.docs[0].get("Description")+'...',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ViewNotifications();
                                      }
                                  ));
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    'More>>',
                                    style: TextStyle(
                                      color: Data.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 0,bottom: 5.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0)
                      ),
                      child: ListTile(
                        title: Container(
                          margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
                          child: Text(
                            "Menu Items",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Container(
                          height: height,
                          child: GridView(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                            children: <Widget> [
                              InkWell(
                                onTap: () {
                                  print("Pressed!");
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return AddDeleteImageSlider();
                                      }
                                  ));
                                },
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.photo_video,
                                        color: Data.primaryColor,
                                        size: 55,
                                      ),
                                      Text(
                                        "Edit ImageSlider",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return Gallery();
                                    }
                                  ));
                                },
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.image,
                                        color: Data.primaryColor,
                                        size: 55,
                                      ),
                                      Text(
                                        "Gallery",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ViewNotifications();
                                    }
                                  ));
                                },
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.bell,
                                        color: Data.primaryColor,
                                        size: 55,
                                      ),
                                      Text(
                                        "Notifications",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return SearchDataEntry();
                                    }
                                  ));
                                },
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.search_location,
                                        color: Data.primaryColor,
                                        size: 55,
                                      ),
                                      Text(
                                        "Orbit Search",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ViewEMagazines();
                                      }
                                  ));
                                },
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.file_contract,
                                        color: Data.primaryColor,
                                        size: 55,
                                      ),
                                      Text(
                                        "E-Read",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return ViewColleges();
                                    }
                                  ));
                                },
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Icon(
                                        LineAwesomeIcons.graduation_cap,
                                        color: Data.primaryColor,
                                        size: 55,
                                      ),
                                      Text(
                                        "List Colleges",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
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
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 5.0,right: 5.0,top: 0,bottom: 15.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0)
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Gallery();
                            },
                          ));
                        },
                        title: Container(
                          margin: EdgeInsets.only(top: 10.0,bottom: 0),
                          child: Text(
                            "Gallery",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Container(
                          height: 140,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 10,bottom: 10, left: 10),
                                height: 150,
                                width: 200,
                                child: (firstLikedImage != null)?CachedNetworkImage(
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                  imageUrl: firstLikedImage,
                                  fit: BoxFit.fitWidth,
                                ):Image.asset(
                                  'assets/loading.gif',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top:10, bottom: 10, left: 10),
                                height: 150,
                                width: 200,
                                child: (secondLikedImage != null)?CachedNetworkImage(
                                  imageUrl: secondLikedImage,
                                  fit: BoxFit.fitWidth,
                                ):Image.asset(
                                  'assets/loading.gif',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                height: 150,
                                width: 200,
                                child: (thirdLikedImage != null)?CachedNetworkImage(
                                  imageUrl: thirdLikedImage,
                                  fit: BoxFit.fitWidth,
                                ):Image.asset(
                                  'assets/loading.gif',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
