import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqllite/Modals/Employee_model.dart';

class MyDatabase {
  static final MyDatabase _myDatabase = MyDatabase._privateConstructor();

  //private Constructor
  MyDatabase._privateConstructor();

  //database
  static late Database _database;

  factory MyDatabase() {
    return _myDatabase;
  }

  //variables
  final String tableName = "emp";
  final String columnId = "id";
  final String columnName = "name";
  final String columnDesignation = "design";
  final String columnIsMale = "isMale";

  //init
  initailizeDatabase() async {
    //get path where to store
    Directory directory = await getApplicationDocumentsDirectory();
    //path
    String path = '${directory.path}emp.db';
    //create database

    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $tableName ($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnDesignation TEXT, $columnIsMale BOOLEAN)');
    });
  }

  //CRUD Functions in sqflite
  // READ
  Future<List<Map<String, Object?>>> getEmpList() async {
    List<Map<String, Object?>> result =
        await _database.query(tableName, orderBy: columnName);
    return result;
  }

  // Future<int> insertEmployee(Employee employee) async {
  //   final db = _database;
  //   return await db.insert(columnName, employee.toMap());
  // }

  Future<int> insertEmployee(Employee employee) async {
    int rowsInserted = await _database.insert(tableName, employee.toMap());
    return rowsInserted;
  }

  //Update
  Future<int> rowsUpdated(Employee employee) async {
    int rowsUpdated = await _database.update(tableName, employee.toMap(),
        where: ' $columnId= ?', whereArgs: [employee.epId]);
    return rowsUpdated;
  }

  //Delete
  Future<int> rowsDeleted(Employee employee) async {
    int rowsDeleted = await _database
        .delete(tableName, where: ' $columnId= ?', whereArgs: [employee.epId]);
    return rowsDeleted;
  }

  //Count
  Future<int> countEmp() async {
    List<Map<String, Object?>> result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }
}
