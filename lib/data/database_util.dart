
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:hiinternet/data/notification_model.dart';

class DatabaseUtil {
  factory DatabaseUtil() {
    return _databaseUtil;
  }

  DatabaseUtil._internal();

  static final DatabaseUtil _databaseUtil = DatabaseUtil._internal();

  Database databaseRef = null;

  void InitDatabase() async {
    openDatabase(
      join(await getDatabasesPath(), 'hiinternet_database.db'),
      onCreate: (db, version) {
        return db.execute(
        'CREATE TABLE notifications(id INTEGER PRIMARY KEY, title TEXT, body TEXT, message TEXT, type_name TEXT, action_url TEXT, created TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    ).then((value) {
      databaseRef = value;
    });
  }

  Future<void> insertNotification(NotiModel notiModel) async {
    if(databaseRef != null) {
      await databaseRef.insert(
        'notifications',
        notiModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

  }

  Future<List<NotiModel>> getAllNotiModels() async {
    if(databaseRef != null) {
      // Query the table for all notifications.
      final List<Map<String, dynamic>> maps = await databaseRef.query('notifications');

      return List.generate(maps.length, (i) {
        return NotiModel.fromJson(maps[i]);
      });
    }

  }

}