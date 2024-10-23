import 'package:evika/data/constants.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/screens/home_page/bloc/home_bloc.dart';
import 'package:evika/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  static Widget builder(BuildContext context, {Key? key}) {
    return BlocProvider(
      create: (context) => HomeBloc(context.read<Repository>())..add(HomeInitialEvent()),
      child: HomePage(key: key),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final _scrollCnt = ScrollController(keepScrollOffset: true);
  bool hasNextEvents = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollCnt.addListener(_loadMore);
  }

  @override
  void dispose() {
    _scrollCnt.dispose();
    super.dispose();
  }

  void _loadMore() {
    // Load more events when scroll to the bottom
    if (hasNextEvents &&
        !isLoading &&
        _scrollCnt.position.pixels == _scrollCnt.position.maxScrollExtent) {
      BlocProvider.of<HomeBloc>(context).add(HomeNextEvents());
      setState(() => isLoading = true);
      debugPrint("Loading...");
    }
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
                icon: SvgPicture.asset('assets/setting.svg',
                    colorFilter: ColorFilter.mode(
                      mainColor,
                      BlendMode.srcIn,
                    )),
                // icon: Icon(Icons.settings_input_component_rounded,
                //     size: 30, color: mainColor),
              )
            ]),
          ),
          BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is HomeNoMoreEventsState) {
                setState(() => hasNextEvents = false);
              } else if (state is HomeFailureState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg)));
              }
              // Set loading to false when state changes
              setState(() => isLoading = false);
            },
            builder: (context, state) {
              if (state.events.isEmpty) return CircularProgressIndicator();
              final myBloc = BlocProvider.of<HomeBloc>(context);
              return Expanded(
                  child: ListView.builder(
                controller: _scrollCnt,
                itemCount: state.events.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: EventCard(
                    event: state.events[i],
                    onLikeTap: () => myBloc.add(HomeLikeEvent(i)),
                    onCommentTap: () => myBloc.add(HomeCommentEvent(i, "hello")),
                    onSaveTap: () => myBloc.add(HomeSavedEvent(i)),
                  ),
                ),
              ));
            },
          ),
          if (isLoading)
            Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                width: double.infinity,
                child: Center(child: const CircularProgressIndicator())),
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
