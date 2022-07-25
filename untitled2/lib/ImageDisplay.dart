import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DatabaseHelper.dart';
import 'NoteList.dart';
import 'Widgets.dart';

class ImagePage extends StatefulWidget {

  String title;
  dynamic link;
  ImagePage(this.link, this.title);

  @override
  State<ImagePage> createState() => ImagePageState(this.title, this.link);
}

class ImagePageState extends State<ImagePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  String title;
  dynamic link;
  int i = 0;
  ImagePageState(this.title, this.link);

  void makeTask() {

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(onPressed: () { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage2(title: 'NoteList',)
              ));}, icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Image.network(this.link)

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: makeTask,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
