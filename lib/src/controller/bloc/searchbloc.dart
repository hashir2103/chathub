import 'dart:async';

import 'package:chathub/src/controller/models/userModel.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  // FirebaseServices _db = FirebaseServices();
  List<MyUser> userList;
  List<MyUser> filterUser;

  final _foldSearchBar = BehaviorSubject<bool>.seeded(true);
  final _showSearchresult = BehaviorSubject<bool>.seeded(false);
  final _query = BehaviorSubject<String>();
  final _queryResult = BehaviorSubject<List<MyUser>>();

  //getter
  Stream<bool> get foldSearchBar => _foldSearchBar.stream;
  Stream<bool> get showSearchResult => _showSearchresult.stream;
  Stream<String> get query => _query.stream;
  Stream<List<MyUser>> get queryResult => _queryResult.stream;

  //setter

  Function(bool) get changeFoldSearchBar => _foldSearchBar.sink.add;
  Function(bool) get changeShowSearchResult => _showSearchresult.sink.add;
  Function(String) get changeQuery => _query.sink.add;
  Function(List<MyUser>) get changeQueryResult => _queryResult.sink.add;

  dispose() {
    _showSearchresult.close();
    _foldSearchBar.close();
    _query.close();
    _queryResult.close();
  }

}
