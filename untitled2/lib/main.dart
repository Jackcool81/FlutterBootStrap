import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:untitled2/Widgets.dart';
import 'DatabaseHelper.dart';
import 'ImageDisplay.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'NoteList.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fpApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _fpApp,
        builder: (context, snapshot) {
          if (snapshot.hasError)
          {
            print("Error");
            return Text("soimething went wrong");
          }
          else if(snapshot.hasData) {
            return Login();
          }
          else {
            return Center(
                child: CircularProgressIndicator()
            );
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? _fileName;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  List<PlatformFile>? _paths;
  FileType _pickingType = FileType.custom;
  String? _fileName3D;
  List<dynamic> _path3D = [];
  bool _isLoading = false;
  String dropdown3DAudio = 'Default 3D Audio';
  String serverUrl = 'http://13a1-35-197-0-58.ngrok.io';
  bool _isUploading = false;
  int i = 0;


  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _uploadFileToServer() async {

    print("uploading ... ");
    setState(() {
      _isUploading = true;
    });
    var url = serverUrl + '/sheetMusic';
    print(url);
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=10, max=1000"
    };

    String? path = _paths![0].path!.substring(1);

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse('$url'));
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'song',
        path,
        //contentType: MediaType('audio', 'midi'),
      ),
    );
    // The following line will enable the Android and iOS wakelock.

    request.send().then((r) async {
      print(r.statusCode);
      // print(json.decode(await r.stream.transform(utf8.decoder).join()));
      if (r.statusCode == 200) {
        var result = json.decode(await r.stream
            .transform(utf8.decoder)
            .join()); //result is going to be a list,
        // Directory tempDir = await getTemporaryDirectory();
        _fileName3D = 'Audio3D';
        print(result);

        setState(() {
          _isUploading = false;
          _path3D = result;

          print(_path3D[0]);


          TaskCardWidget _newTask = TaskCardWidget("Sample" + i.toString(), _path3D[0]);
          i++;
          uploadData(_newTask);
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Homepage2(title: 'NoteList',)
              ));
          if (_path3D != "") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImagePage(_path3D[0], "editing")));
          }

        });
        // The next line disables the wakelock again.

      } else {
        print("Failed to get the response correctly!");
        setState(() {
          _isUploading = false;
        });
        // The next line disables the wakelock again.

      }
    });

    // TaskCardWidget _newTask = TaskCardWidget("https://firebasestorage.googleapis.com/v0/b/msuci-thingy.appspot.com/o/music%2Fbeet%2Fbeet-1.png?alt=media&token=2797ca7f-0194-48ac-a451-802d42eb9902", "Sample");
    // uploadData(_newTask);
    //
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ImagePage("this title", "https://firebasestorage.googleapis.com/v0/b/msuci-thingy.appspot.com/o/music%2Fbeet%2Fbeet-1.png?alt=media&token=2797ca7f-0194-48ac-a451-802d42eb9902")));
  }


  void uploadData(TaskCardWidget task) async {
    await _dbHelper.insertTask(task);
  }




  void _pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['mp3', 'wav'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : 'unknown';
    });
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _paths = null;
      _isLoading = false;
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [
            InkWell(
                onTap: _uploadFileToServer,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                      color: Colors.lightBlue,
                      width: 300,
                      height: 150,
                      child: Text("Upload File", style: TextStyle(fontSize: 60.0))),
                )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: _pickFiles,
                child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Container(
                        color: Colors.deepPurpleAccent,
                        width: 150,
                        height: 150,
                        child: Text("Pick File", style: TextStyle(fontSize: 40.0))))),
                InkWell(
                    onTap: () {
                      List<dynamic> json = [];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage2(title: 'feuibas')));

                    },
                    child: Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Container(
                        color: Colors.indigo, width: 150, height: 150,
                        child: Text("History", style: TextStyle(fontSize: 40.0)))),

                )])
          ]),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
