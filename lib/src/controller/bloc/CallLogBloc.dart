import 'package:chathub/src/backend/Local%20DB/db/hive.dart';
import 'package:chathub/src/backend/Local%20DB/db/sqlite.dart';
import 'package:chathub/src/controller/models/CallLog.dart';
import 'package:flutter/foundation.dart';

class LogBloc {
  static var dbObject;
  static bool isHive;

  static init({@required bool ishive}) {
    dbObject = ishive ? HiveDB() : SqliteDB();
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
