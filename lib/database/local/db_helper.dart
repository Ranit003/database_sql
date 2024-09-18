import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBhelper {
  /// singelton class
  DBhelper._();

  Database? myDB;
  static final DBhelper getinstance = DBhelper._();
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NAME_SNO = "s_no";
  static final String COLUMN_NAME_TITLE = "title";
  static final String COLUMN_NAME_DESC = "desc";

  ///db open(path->if exist then open else create)
  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appdir = await getApplicationDocumentsDirectory();

    String dbPath = join(appdir.path, "noteDB.db");

    return await openDatabase(dbPath, onCreate: (db, version) {
      ///CREATE ALL TABLES HERE

      db.execute(
          "create table $TABLE_NOTE(s_no integer primary key autoincrement ,title text,desc text)");
    }, version: 1);
  }

  /// write queries

  Future<bool> addNote({required String mtitle, required String mdesc}) async {
    var db = await getDB();
    int rowsaffected = await db.insert(TABLE_NOTE, {
      COLUMN_NAME_TITLE: mtitle,
      COLUMN_NAME_DESC: mdesc,

    });

    return rowsaffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    ///SELECT * FROM
    List<Map<String, dynamic>> mdata = await db.query(TABLE_NOTE);
    return mdata;
  }

  ///update note
  Future<bool> updateNote(
      {required String mtitle, required String mdesc, required int sno}) async {
    var db = await getDB();
    int rowsaffected = await db.update(TABLE_NOTE, {
      COLUMN_NAME_TITLE: mtitle,
      COLUMN_NAME_DESC: mdesc,}, where: "$COLUMN_NAME_SNO=$sno"
    );
    return rowsaffected > 0;
  }

  // delete note
  Future<bool> deleteNote(param0,
      {required String mtitle, required String mdesc, required int sno}) async {
    var db = await getDB();
    int rowsaffected = await db.delete(
        TABLE_NOTE, where: "$COLUMN_NAME_SNO=?", whereArgs: ['$sno']);
    return rowsaffected > 0;
  }
}
