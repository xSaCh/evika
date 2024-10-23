import 'dart:convert';
import 'dart:io';

import 'package:evika/data/api.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/local_repository.dart';
import 'package:flutter/material.dart';

class Repository {
  final Api api;
  final LocalRepository localRepo;
  Repository(this.api, this.localRepo);

  Future<LoginUser?> loginUser(String email, String password) async {
    final res = await api.loginUser(email, password);

    if (res.$2 != "") localRepo.setToken(res.$2);
    return res.$1;
  }

  Future<(List<Event>, int)> getEvents({int page = 1}) async {
    debugPrint("Fetching $page events...");
    throw UnimplementedError();
    // final eventRes = await api.getEvents(page: page);

    // Cached lastest events to local DB
    // if (eventRes.$1.isNotEmpty) localRepo.setEvents(eventRes.$1);

    // return eventRes;
    File f = File("/home/samarth/events.json");
    final data = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    final eventsMap = data['data']['events'];
    List<Event> newEvent =
        await eventsMap.map<Event>((event) => Event.fromMap(event)).toList();

    if (newEvent.isNotEmpty) localRepo.setEvents(newEvent);

    return (newEvent, 6);
  }

  List<Event> getEventsCached() {
    return localRepo.getEvents();
  }
}
