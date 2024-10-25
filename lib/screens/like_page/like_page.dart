import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:evika/data/constants.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/widgets/event_card.dart';

import 'bloc/like_bloc.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();

  static Widget builder(BuildContext context, {Key? key}) {
    return BlocProvider(
      create: (context) => LikeBloc(context.read<Repository>())..add(LikeInitialEvent()),
      child: LikePage(key: key),
    );
  }
}

class _LikePageState extends State<LikePage> with AutomaticKeepAliveClientMixin {
  final _scrollCnt = ScrollController(keepScrollOffset: true);
  bool hasNextEvents = true;
  bool isLoading = true;

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

  @override
  bool get wantKeepAlive => true;

  void _loadMore() {
    // Load more events when scroll to the bottom
    if (hasNextEvents &&
        !isLoading &&
        _scrollCnt.position.pixels == _scrollCnt.position.maxScrollExtent) {
      BlocProvider.of<LikeBloc>(context).add(LikeNextEvents());
      setState(() => isLoading = true);
      debugPrint("Loading...");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Liked Events",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications_sharp))],
      ),
      backgroundColor: Colors.grey,
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<LikeBloc>(context).add(LikeInitialEvent());
          setState(() => isLoading = true);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              BlocConsumer<LikeBloc, LikeState>(
                listener: (context, state) {
                  if (state is LikeNoMoreEventsState) {
                    setState(() => hasNextEvents = false);
                  } else if (state is LikeFailureState) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.errorMsg)));
                  }
                  // Set loading to false when state changes
                  setState(() => isLoading = false);
                },
                builder: (context, state) {
                  if (!isLoading && state.events.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: Text("No Liked Events Found")),
                    );
                  }
                  final myBloc = BlocProvider.of<LikeBloc>(context);
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    controller: _scrollCnt,
                    itemCount: state.events.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: EventCard(
                        event: state.events[i],
                        onLikeTap: () => myBloc.add(LikeLikeEvent(i)),
                        onCommentTap: (v) => myBloc.add(LikeCommentEvent(i, v)),
                        onSaveTap: () => myBloc.add(LikeSavedEvent(i)),
                      ),
                    ),
                  );
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
        ),
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
