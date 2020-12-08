import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wafy_updates/add_data_entry.dart';
import 'admin_data_entry_list.dart';
import 'data.dart';

class AdminSearchDataEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Orbit Search',
            style: TextStyle(
              color: Colors.white,
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
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(
                Icons.school,
                color: Colors.white,
              )),
              Tab(icon: Icon(
                Icons.location_city,
                color: Colors.white,
              )),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add_box,
            color: Colors.white,
          ),
          backgroundColor: Data.primaryColor,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return DataEntry();
                }
            ));
          },
        ),
        body: AdminSearchDataEntryBody(),
      ),
    );
  }
}

class AdminSearchDataEntryBody extends StatefulWidget {
  @override
  _AdminSearchDataEntryBodyState createState() => _AdminSearchDataEntryBodyState();
}

class _AdminSearchDataEntryBodyState extends State<AdminSearchDataEntryBody> {

  String collegeDropdown = Data.collegeValues[0];
  String orbitDropdown = Data.orbitValues[0];

  collegeDataEntry () {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(
              color: Colors.black45,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: SizedBox(
            height: 45.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.only(top: 9.0,right: 0.0, left: 7.0),
                  child: Icon(
                    Icons.location_city,
                    color: Data.primaryColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 13.0,left: 10.0),
                  child: Text(
                    "College:",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                  child: DropdownButton<String>(
                    value: collegeDropdown,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: DropdownButtonHideUnderline(
                      child: Container(),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        collegeDropdown = newValue;
                        print(collegeDropdown);
                        print(newValue);
                      });
                    },
                    items: Data.collegeValues
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          child: Text("Search"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(
              color: Data.primaryColor,
              width: 2.5,
            ),
          ),
          color: Data.primaryColor,
          textColor: Colors.white,
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return AdminDataEntryList(collegeDropdown);
                }
            ));
          },
        ),
      ],
    );
  }

  orbitDataEntry () {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0,left: 15.0,right: 15.0,bottom: 0.0),
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(
              color: Colors.black45,
              width: 1.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          child: SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.only(top: 9.0,right: 0.0, left: 7.0),
                  child: Icon(
                    Icons.assignment_ind_outlined,
                    color: Data.primaryColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 13.0,left: 10.0),
                  child: Text(
                    "Orbit:",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0,bottom: 3.0),
                  child: DropdownButton<String>(
                    value: orbitDropdown,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: DropdownButtonHideUnderline(
                      child: Container(),
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        orbitDropdown = newValue;
                        print(orbitDropdown);
                        print(newValue);
                      });
                    },
                    items: Data.orbitValues.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        RaisedButton(
          child: Text("Search"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(
              color: Data.primaryColor,
              width: 2.5,
            ),
          ),
          color: Data.primaryColor,
          textColor: Colors.white,
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return AdminDataEntryList(orbitDropdown);
                }
            ));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        collegeDataEntry(),
        orbitDataEntry(),
      ],
    );
  }
}
