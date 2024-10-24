import 'package:evika/data/constants.dart';
import 'package:evika/data/debouncer.dart';
import 'package:evika/data/models/login_user.dart';
import 'package:evika/data/repositories/repository.dart';
import 'package:evika/data/util.dart';
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

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  final _scrollCnt = ScrollController(keepScrollOffset: true);
  final _searchTxtCnt = TextEditingController();
  final debouncer = Debouncer();

  LoginUser? user;
  bool hasNextEvents = true;
  bool isLoading = true;
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _scrollCnt.addListener(_loadMore);
    user = context.read<Repository>().loggedUser;
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
      BlocProvider.of<HomeBloc>(context).add(HomeNextEvents());
      setState(() => isLoading = true);
      debugPrint("Loading...");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: mainColor),
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: mainColor),
                  accountName: Text("${user?.firstName} ${user?.lastName}",
                      style: TextStyle(fontSize: 18)),
                  accountEmail: Text(user?.email ?? ""),
                  currentAccountPictureSize: Size.square(40),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: secondaryColor,
                    child: Text(
                      user?.firstName[0] ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ),
                ),
              ),
              ListTile(
                  leading: const Icon(Icons.person), title: const Text(' My Profile ')),
              ListTile(leading: const Icon(Icons.book), title: const Text(' My Events ')),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Demo App",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.notifications_sharp))],
        ),
        backgroundColor: Colors.grey,
        body: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
          if (state is HomeNoMoreEventsState) {
            setState(() => hasNextEvents = false);
          } else if (state is HomeFailureState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMsg)));
          }
          // Set loading to false when state changes
          setState(() => isLoading = false);
        }, builder: (context, state) {
          final myBloc = BlocProvider.of<HomeBloc>(context);
          var filteredEvents = state.events;
          if (selectedCategories.isNotEmpty) {
            filteredEvents = state.events
                .where((e) => containsAny(
                    e.eventCategory.map((c) => getCategoryNameFromId(c)).toList(),
                    selectedCategories))
                .toList();
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(child: searchBar()),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => buildFilter(state.uniqueCategories),
                    child: SvgPicture.asset(
                      'assets/setting.svg',
                      colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                      width: 35,
                      height: 35,
                    ),
                  )
                ]),
              ),
              if (!isLoading && state.events.isEmpty)
                Center(child: Text("No Events Found"))
              else
                Expanded(
                    child: ListView.builder(
                  controller: _scrollCnt,
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: EventCard(
                      event: filteredEvents[i],
                      onLikeTap: () => myBloc.add(HomeLikeEvent(i)),
                      onCommentTap: () => myBloc.add(HomeCommentEvent(i, "hello")),
                      onSaveTap: () => myBloc.add(HomeSavedEvent(i)),
                    ),
                  ),
                )),
              if (isLoading)
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.white,
                    width: double.infinity,
                    child: Center(child: const CircularProgressIndicator())),
            ],
          );
        }));
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.black, fontSize: 18),
        textAlignVertical: TextAlignVertical.center,
        controller: _searchTxtCnt,
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 30),
          hintText: "Search messages",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          border: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        onChanged: (value) => debouncer.run(() {
          BlocProvider.of<HomeBloc>(context).add(HomeSearchEvent(value));
          _scrollCnt.animateTo(0,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }),
      ),
    );
  }

  void buildFilter(Set<String> uniqueCategories) {
    debugPrint(uniqueCategories.toString());
    final bloc = BlocProvider.of<HomeBloc>(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryFilter(uniqueCategories.toList(), selectedCategories,
                    (i, sel) {
                  setState(() {
                    if (sel) {
                      selectedCategories.add(uniqueCategories.elementAt(i));
                    } else {
                      selectedCategories.remove(uniqueCategories.elementAt(i));
                    }
                  });
                }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => setState(() => selectedCategories.clear()),
                        child: Text("Reset")),
                    FilledButton(
                      onPressed: () {
                        bloc.add(HomeFilterEvent(selectedCategories));
                        Navigator.pop(context);
                      },
                      child: Text("Apply"),
                    )
                  ],
                ),
              ],
            ),
          );
        });
      },
      backgroundColor: Colors.white,
      enableDrag: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2)),
    );
  }

  Widget _buildCategoryFilter(List<String> categories, List<String> selectedCategories,
      void Function(int, bool)? onCategoryChange) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text("  Categories: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ...List.generate(categories.length, (i) {
            final isSelected = selectedCategories.contains(categories[i]);
            return Padding(
              padding: EdgeInsets.only(left: 8),
              child: ChoiceChip(
                selected: isSelected,
                onSelected: (bool selected) => onCategoryChange?.call(i, selected),
                label: Text(
                  categories[i],
                  style: TextStyle(color: isSelected ? Colors.white : Colors.blueGrey),
                ),
                labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                visualDensity: const VisualDensity(horizontal: 0.0, vertical: -4),
                showCheckmark: false,
                selectedColor: mainColor,
              ),
            );
          })
        ],
      ),
    );
  }
}
