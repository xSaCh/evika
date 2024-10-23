import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:evika/data/api.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/user.dart';
import 'package:evika/data/repositories/local_repository.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/screens/base_screen.dart';
import 'package:evika/screens/login_page/login_page.dart';

void main() async {
  final a = Api("https://evika.onrender.com");
  // final o = await a.loginUser("vikramnegi175@gmail.com", "123456789");
  // final e = await a.getEvents();
  // final e2 = await a.getEvents(page: 2);
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Event>('events');

  final repo = Repository(a, LocalRepository());

  runApp(MultiRepositoryProvider(
    providers: [RepositoryProvider<Repository>(create: (context) => repo)],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evika',
      home: BaseScreen(),
    );
  }
}
