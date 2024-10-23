import 'package:evika/data/models/event.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalRepository {
  late Box<Event> eventBox;

  LocalRepository() {
    eventBox = Hive.box("events");
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

  List<Event> getEvents() {
    return eventBox.values.toList();
  }
}
