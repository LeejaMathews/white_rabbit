import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:white_rabbit/database.dart';
import 'package:white_rabbit/model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseClass.database = openDatabase(
    join(await getDatabasesPath(), 'db_demo.db'),
    onCreate: (db, version) async {
      print("onCreate");
      await DatabaseClass.createTable(db);
    },
    version: 1,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'White Rabbit Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Person> person;
  List<Person> _personList = [

//    Person(name: "Leanne Graham",
//        profileImage: "https://randomuser.me/api/portraits/men/1.jpg",
//        company: Company(name: "Romaguera-Crona")),
//    Person(name: "Leanne Graham",
//        profileImage: "https://randomuser.me/api/portraits/men/1.jpg",
//        company: Company(name: "Romaguera-Crona")),
//    Person(name: "Leanne Graham",
//        profileImage: "https://randomuser.me/api/portraits/men/1.jpg",
//        company: Company(name: "Romaguera-Crona")),

  ];


  @override
  void initState() {
    super.initState();
    person = fetchAlbum();
    DatabaseClass.getPersons().then((value) {
      setState(() {
        _personList = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Person>(
          future: person,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data:snapshot.data as List<Person>;
              return Container
                (
                  child: ListView.builder(
                    itemBuilder: (cont, index) {
                      return ListTile(
                        title: Text(_personList[index].name!),
                        subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(_personList[index].profileImage!),
                        Text(_personList[index].company!.name!),

                        ],
                      ),);
                    },
                  ));
            }
            return Text("${snapshot.error}");
          }
      ),
    );
  }
}


Future<Person> fetchAlbum() async {
  var url = Uri.parse('http://www.mocky.io/v2/5d565297300000680030a986');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return Person.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}