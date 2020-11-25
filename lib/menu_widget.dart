import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:wafy_updates/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';
import 'profile.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.70,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Data.primaryColor,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                    future: FirebaseStorage.instance.ref().child(user.uid).getDownloadURL(),
                    builder: (context, AsyncSnapshot <dynamic> snapshot) {
                      if(snapshot.hasData) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(
                                snapshot.data,
                              ),
                            ),
                          ),
                        );
                      }
                      else {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(
                                'https://media.tenor.com/images/67d17766117cca8152040f688609472b/tenor.gif',
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection('Registered Users').doc(user.email).get(),
                    builder: (context, AsyncSnapshot <DocumentSnapshot> snapshot) {
                      if(snapshot.hasData) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            snapshot.data.get('Name'),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                      else {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            'Retrieving...',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          InkWell(onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) {
                return Profile();
              }
            ));
          },child: IgnorePointer(child: sliderItem('Profile', EvaIcons.person))),
          InkWell(onTap: () {
            Share.share('WAFY UPDATES'+
                '\nവാഫി/വഫിയ്യ/വഫിയ്യ ഡേ യുടെ പുതിയ വിവരങ്ങൾ അറിയാൻ ഈ ആപ്പ് ഡൌൺലോഡ് ചെയ്യൂ..'+
                '\n\nwww.google.com');
          },child: IgnorePointer(child: sliderItem('Share App', Icons.share))),
          InkWell(onTap: () {
            launch('https://m.facebook.com/wsfcic/');
          },child: IgnorePointer(child: sliderItem('Like our FB page', EvaIcons.facebook))),
          InkWell(onTap: () {
            launch('https://www.instagram.com/wsf_state/?igshid=16yd4hsk8rn4q');
          },child: IgnorePointer(child: sliderItem('Like our Instagram', LineAwesomeIcons.instagram))),
          InkWell(onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return Login();
                }
              ));
            });
          },child: IgnorePointer(child: sliderItem('Logout', Icons.logout))),
          InkWell(onTap: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },child: IgnorePointer(child: sliderItem('Exit', Icons.exit_to_app))),
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => ListTile(
      title: Text(
        title,
        style:
        TextStyle(color: Colors.black, fontFamily: 'BalsamiqSans_Regular'),
      ),
      leading: Icon(
        icons,
        color: Colors.black,
      ),
      onTap: () {

      });
}

