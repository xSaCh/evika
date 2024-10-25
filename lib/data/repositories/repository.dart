import 'package:flutter/material.dart';

import 'package:evika/data/api.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/local_repository.dart';

class Repository {
  final Api api;
  final LocalRepository localRepo;
  LoginUser? loggedUser;

  Repository(this.api, this.localRepo);

  Future<void> initDB() async => localRepo.initDB();

  Future<LoginUser?> loginUser(String email, String password) async {
    debugPrint("Logging in...");
    final res = await api.loginUser(email, password);
    debugPrint("Logged in as ${res.$1?.email}");

    if (res.$2 != "") localRepo.setToken(res.$2);
    loggedUser = res.$1;
    return res.$1;
  }

  Future<(List<Event>, int)> getEvents({int page = 1}) async {
    debugPrint("Fetching $page events...");
    final eventRes = await api.getEvents(page: page);

    // Get local stored interactions
    for (var e in eventRes.$1) {
      final intr = localRepo.getEventInteraction(e.id);
      if (intr != null) e.setInteractionFields(intr);
    }
    // Cached lastest events to local DB
    if (eventRes.$1.isNotEmpty) localRepo.setEvents(eventRes.$1);

    return eventRes;
  }

  Future<(List<Event>, int)> searchEvents(String query, {int page = 1}) async {
    debugPrint("Searching $page events...");

    final eventRes = await api.searchEvents(query, page: page);

    // Get local stored interactions
    for (var e in eventRes.$1) {
      final intr = localRepo.getEventInteraction(e.id);
      if (intr != null) e.setInteractionFields(intr);
    }

    return eventRes;
  }

  Future<void> setEventInteraction(Event event) async {
    return localRepo.setEventInteraction(event);
  }

  List<Event> getEventsCached() {
    var events = localRepo.getEvents();

    for (var e in events) {
      final intr = localRepo.getEventInteraction(e.id);
      if (intr != null) e.setInteractionFields(intr);
    }
    return events;
  }
}
