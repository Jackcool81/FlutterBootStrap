// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:textapp/Widgets.dart';
// import 'DataBaseHelper.dart';
// import 'notespage.dart';
import 'DatabaseHelper.dart';
import 'Widgets.dart';

class Homepage2 extends StatefulWidget {
  final String title;


  const Homepage2({Key? key, required this.title}) : super(key: key);


  @override
  _HomepageState2 createState() => _HomepageState2();
}


class _HomepageState2 extends State<Homepage2> {
  // DatabaseHelper _db = DatabaseHelper();
  List<TaskCardWidget> data = [];
  DatabaseHelper _db = DatabaseHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  void _incrementCounter() {
    // DatabaseReference _testRef = FirebaseDatabase.instance.ref().child("test");
    // _testRef.set("Hello world");
    List<dynamic> json = [];
    String title = "Enter Text";

  }


  void initState() {

    DatabaseReference _db1 = FirebaseDatabase.instance.ref("users");

    String currentuser = _auth.currentUser!.uid;

    var ref = _db1.child(currentuser).child('tasks');
    ref.onValue.listen((event) async {
      //i = 0;
      int x = event.snapshot.children.length;
      print(x);
      data.clear();
      int t = 0;
      for (DataSnapshot i in event.snapshot.children){
        // title = event.snapshot.children.elementAt(i).value.toString();

        setState(() => data.insert(t, (TaskCardWidget(
          i.children.elementAt(1).value.toString(),
          i.children.elementAt(0).value.toString(),
        ))));
        // data[t] = TaskCardWidget(i.children.elementAt(1).value.toString(), i.children.elementAt(0).value.toString());
        t++;
      };
    });

    // setState(() =>
    // data = _db.getValue());
    // list();

  }

  List<Widget> list() {

    setState(() =>

    data = _db.getValue());
    return data;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 32.0,
          ),
          child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListView(
                            children:
                                _db.getValue()
                        )
                    ),

                  ],
                ),
              ]),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),);
  }
}