
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Widgets.dart';


class DatabaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  String title = "unnamed task";
  final List<TaskCardWidget> data = <TaskCardWidget>[];
  // late UserCredential user;

  List<dynamic> myJson = [];
  String myTitle = "Enter Text";

  insertTask(TaskCardWidget task) async {
    DatabaseReference _db1 = FirebaseDatabase.instance.ref("users");
    String? currentUser = _auth.currentUser?.uid;
    // DatabaseReference _db1 = FirebaseDatabase.instance.ref();
    _db1.child(currentUser!).child('tasks').child(task.title).set(task.toMap());
  }

  List<dynamic> getSingleJson(String title) {
    DatabaseReference _db1 = FirebaseDatabase.instance.ref()
        .child('tasks')
        .child(title);
    _db1.onValue.listen((event) {

      String task = event.snapshot.children
          .elementAt(0)
          .value
          .toString();
      myJson = jsonDecode(task);

    });
    return myJson;
  }

  String getSingleTitle(String title) {
    DatabaseReference _db1 = FirebaseDatabase.instance.ref()
        .child('tasks')
        .child(title);
    _db1.onValue.listen((event) {

      myTitle = event.snapshot.children
          .elementAt(1)
          .value
          .toString();

    });
    return myTitle;
  }





  List<TaskCardWidget> getValue() {

    String currentuser = _auth.currentUser!.uid;
    DatabaseReference _db1 = FirebaseDatabase.instance.ref(
        "users"
    );

    var ref = _db1.child(currentuser).child('tasks');
    ref.onValue.listen((event) {
      //i = 0;
      int x = event.snapshot.children.length;
      print(x);
      data.clear();
      int t = 0;
      for (DataSnapshot i in event.snapshot.children){
        // title = event.snapshot.children.elementAt(i).value.toString();

        data.insert(t, (TaskCardWidget(
          i.children.elementAt(1).value.toString(),
          i.children.elementAt(0).value.toString(),
        )));
        // data[t] = TaskCardWidget(i.children.elementAt(1).value.toString(), i.children.elementAt(0).value.toString());
        t++;
      };
    });
    print(data);
    return data;
  }
}