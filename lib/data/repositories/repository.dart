import 'dart:convert';
import 'dart:io';

import 'package:evika/data/api.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/local_repository.dart';

class Repository {
  final Api api;
  final LocalRepository localRepo;
  Repository(this.api, this.localRepo);

  Future<LoginUser?> loginUser(String email, String password) async {
    final res = await api.loginUser(email, password);

    if (res.$2 != "") localRepo.setToken(res.$2);
    return res.$1;
  }

  Future<List<Event>> getEvents({int page = 1}) async {
    // return api.getEvents(page: page);
    File f = File("/home/samarth/events.json");
    final data = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    final eventsMap = data['data']['events'];
    return eventsMap.map<Event>((event) => Event.fromMap(event)).toList();
  }

  Future<List<Event>> getEventsCached({int page = 1}) async {
    return [];
  }
}
