import 'dart:convert';
// import 'DataBaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'ImageDisplay.dart';



class TaskCardWidget extends StatelessWidget {
  late final String title;
  late final String link;
  // DatabaseHelper _db = DatabaseHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  Map<String, String> toMap() {
    return {
      'title': title,
      'json' : link
    };
  }

  TaskCardWidget(this.title, this.link);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {


          String currentuser = _auth.currentUser!.uid;
          DatabaseReference _db1 = FirebaseDatabase.instance.ref("users").child(currentuser).child("tasks").child(this.title);


          String? currentUser = _auth.currentUser?.uid;
          _db1.onValue.listen((event)  {

            String task = event.snapshot.children
                .elementAt(0)
                .value
                .toString();


            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImagePage(task, this.title)
                ));
          });

        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: 32.0,
            horizontal: 24.0,
          ),
          margin: EdgeInsets.only(
            bottom: 20.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.title,
                style: TextStyle(
                  color: Color(0xFF211551),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
        )
    );
  }
}
