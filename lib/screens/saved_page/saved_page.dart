import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:evika/data/constants.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/widgets/event_card.dart';

import 'bloc/saved_bloc.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();

  static Widget builder(BuildContext context, {Key? key}) {
    return BlocProvider(
      create: (context) =>
          SavedBloc(context.read<Repository>())..add(SavedInitialEvent()),
      child: SavedPage(key: key),
    );
  }
}

class _SavedPageState extends State<SavedPage> {
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
      BlocProvider.of<SavedBloc>(context).add(SavedNextEvents());
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
          "Saved Events",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications_sharp))],
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          BlocConsumer<SavedBloc, SavedState>(
            listener: (context, state) {
              if (state is SavedNoMoreEventsState) {
                setState(() => hasNextEvents = false);
              } else if (state is SavedFailureState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.errorMsg)));
              }
              // Set loading to false when state changes
              setState(() => isLoading = false);
            },
            builder: (context, state) {
              if (state.events.isEmpty) return CircularProgressIndicator();
              final myBloc = BlocProvider.of<SavedBloc>(context);
              return Expanded(
                  child: ListView.builder(
                controller: _scrollCnt,
                itemCount: state.events.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: EventCard(
                    event: state.events[i],
                    onLikeTap: () => myBloc.add(SavedLikeEvent(i)),
                    onCommentTap: () => myBloc.add(SavedCommentEvent(i, "hello")),
                    onSaveTap: () => myBloc.add(SavedSavedEvent(i)),
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
    padding: const EdgeInsets.symmetric(horizontal: 6),
    decoration: BoxDecoration(
      color: secondaryColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      style: const TextStyle(color: Colors.black, fontSize: 18),
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 30),
        hintText: "Search messages",
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    ),
  );
}
