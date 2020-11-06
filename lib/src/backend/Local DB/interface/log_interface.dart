import 'package:chathub/src/controller/models/CallLog.dart';

abstract class LogInterface {
  init();

  addLogs(Log log);

  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  close();
}
