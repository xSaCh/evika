import 'package:evika/data/repositories/repository.dart';
import 'package:evika/screens/home_page/bloc/home_bloc.dart';
import 'package:evika/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(context.read<Repository>())..add(HomeInitialEvent()),
      child: HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Demo App",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications_sharp))],
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: searchBar()),
              SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings_input_component_rounded,
                    size: 30, color: Color(0xFF0A66C2)),
              )
            ]),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.events.isEmpty) return CircularProgressIndicator();
              final myBloc = BlocProvider.of<HomeBloc>(context);
              return Expanded(
                  child: ListView.builder(
                itemCount: state.events.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: EventCard(
                    event: state.events[i],
                    onLikeTap: () => myBloc.add(HomeLikeEvent(i)),
                    onCommentTap: () => myBloc.add(HomeCommentEvent(i, "hello")),
                    onShareTap: () => myBloc.add(HomeSavedEvent(i)),
                  ),
                ),
              ));
            },
          )
        ],
      ),
    );
  }
}

Widget searchBar({TextEditingController? controller}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
      color: Color(0xFFEBF2FA),
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      style: const TextStyle(color: Colors.black, fontSize: 18),
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 30),
        hintText: "Search messages",
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    ),
  );
}
