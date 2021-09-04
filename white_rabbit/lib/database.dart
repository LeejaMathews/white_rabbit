import 'package:sqflite/sqlite_api.dart';
import 'package:white_rabbit/model.dart';

class DatabaseClass {
  static Future<Database>? database;

  static Future<void> clearTable() async {
    final Database? db = await DatabaseClass.database;
    await db!.delete("profile_table");
  }

  static Future<void> insertPerson(Person person) async {
    final Database? db = await DatabaseClass.database;
    await db!.insert("profile_table", {
      "name": person.name,
      "profileImage": person.profileImage,
      "companyName": person.company!.name,

    });
  }

  static Future<List<Person>> getPersons() async {
    List<Person> _personList = [];
    final Database? db = await DatabaseClass.database;
    print("before getPersons");
    await db!.query("profile_table").then((value) {
      if (value.isNotEmpty) {
        _personList = List.generate(
            value.length, (index) => Person.fromJson(value[index]));
      }
    });
    print(_personList);
    return _personList;
  }

  static Future<void> createTable(Database db) async {
    await db.execute("CREATE TABLE IF NOT EXISTS profile_table ("
        "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
        "name TEXT NOT NULL,"
        "profileImage TEXT NOT NULL,"
        "companyName TEXT NOT NULL,)"
    );
  }
}
