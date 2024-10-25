import 'dart:convert';
import 'dart:io';

import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/event_interaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepository {
  late Box<Event> eventBox;
  late Box<EventInteraction> eventInteractionBox;

  LocalRepository() {
    eventBox = Hive.box("events");
    eventInteractionBox = Hive.box("eventInteractions");
  }

  Future<void> initDB() async {
    await eventBox.clear();
    String eventLocalData = File('assets/events.json').readAsStringSync();
    jsonDecode(eventLocalData)['data']['events']
        .forEach((event) async => await eventBox.add(Event.fromMap(event)));
  }

  Future setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void setEvents(List<Event> events) async {
    await eventBox.clear();
    await eventBox.addAll(events);
  }

  Future<void> setEventInteraction(Event event) async {
    return eventInteractionBox.put(event.id, EventInteraction.fromEvent(event));
  }

  EventInteraction? getEventInteraction(String eventId) {
    return eventInteractionBox.get(eventId);
  }

  List<Event> getEvents() {
    return eventBox.values.toList();
  }
}
