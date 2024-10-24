import 'package:evika/data/constants.dart';
import 'package:evika/data/models/event_interaction.dart';
import 'package:evika/screens/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:evika/data/api.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/data/models/user.dart';
import 'package:evika/data/repositories/local_repository.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/screens/login_page/login_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(EventInteractionAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Event>('events');
  await Hive.openBox<EventInteraction>('eventInteractions');

  final repo = Repository(Api("https://evika.onrender.com"), LocalRepository());
  final o = await repo.loginUser("vikramnegi175@gmail.com", "123456789");

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(TextStyle(color: Colors.white)),
        ),
        useMaterial3: true,
      ),
      title: 'Evika',
      home: LoginScreen.builder(context),
      // home: BaseScreen(),
    );
  }
}
