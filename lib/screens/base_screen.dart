import 'package:evika/data/constants.dart';
import 'package:evika/data/models/event.dart';
import 'package:evika/screens/home_page/home_page.dart';
import 'package:evika/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageStorageBucket _bucket = PageStorageBucket();
  final PageController _pageController = PageController(keepPage: true);
  late List<Widget> _pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    _pages = [
      HomePage.builder(context, key: PageStorageKey('homePage')),
      Center(child: Text("Liked")),
      Center(child: Text("Saved ")),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIndex: _selectedIndex,
          indicatorColor: Colors.transparent,
          height: 70,
          destinations: [
            NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/home.svg",
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                selectedIcon: SvgPicture.asset(
                  "assets/home.svg",
                  colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                ),
                label: 'Home'),
            NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/heart.svg",
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                selectedIcon: SvgPicture.asset(
                  "assets/heart.svg",
                  colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                ),
                label: 'Liked'),
            NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/network.svg",
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                selectedIcon: SvgPicture.asset(
                  "assets/network.svg",
                  colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                ),
                label: 'Community'),
            NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/saved.svg",
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                selectedIcon: SvgPicture.asset(
                  "assets/saved.svg",
                  colorFilter: ColorFilter.mode(mainColor, BlendMode.srcIn),
                ),
                label: 'Saved'),
          ],
          onDestinationSelected: _onItemTapped,
        ),
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _selectedIndex = index),
        children: _pages,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.blue,
      //   onTap: _onItemTapped,
      // ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
