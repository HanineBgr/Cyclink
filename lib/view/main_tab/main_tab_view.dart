import 'package:fast_rhino/view/Workout/trainingSession.dart';
import 'package:fast_rhino/view/planning/planning_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/view/Workout/workout_library.dart';
import 'package:fast_rhino/view/home/home_view.dart';
import 'package:fast_rhino/view/profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  final int initialTabIndex;

  const MainTabView({super.key, this.initialTabIndex = 0});

  @override
  State<MainTabView> createState() => _MainTabViewState();

  static _MainTabViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainTabViewState>();
}

class _MainTabViewState extends State<MainTabView> with WidgetsBindingObserver {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  late Widget currentTab;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selectTab = widget.initialTabIndex;
    currentTab = _getTabForIndex(selectTab);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      final prefs = await SharedPreferences.getInstance();
      final screenName = switch (selectTab) {
        0 => 'HomeView',
        1 => 'WorkoutLibrary',
        2 => 'LiveSession',
        3 => 'Planning',
        4 => 'Profile',
        _ => 'HomeView',
      };
      await prefs.setString('lastScreen', screenName);
    }
  }

  Widget _getTabForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeViewScreen();
      case 1:
        return WorkoutLibrary(eObj: {"name": "Workout Library"});
      case 2:
        return const Placeholder(); // Replace with LiveSessionScreen if needed
      case 3:
        return PlanningScreen();
      case 4:
        return const ProfileView();
      default:
        return const HomeViewScreen();
    }
  }

  Widget buildTabIcon(Widget iconWidget, bool isActive, VoidCallback onTap) {
    return IconButton(
      icon: iconWidget,
      onPressed: onTap,
      splashRadius: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: TColor.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTabIcon(
                Icon(
                  Icons.home,
                  color: selectTab == 0 ? TColor.secondaryColor2 : Colors.grey,
                ),
                selectTab == 0,
                () {
                  setState(() {
                    selectTab = 0;
                    currentTab = _getTabForIndex(selectTab);
                  });
                },
              ),
              buildTabIcon(
                Icon(
                  Icons.list_rounded,
                  color: selectTab == 1 ? TColor.secondaryColor2 : Colors.grey,
                ),
                selectTab == 1,
                () {
                  setState(() {
                    selectTab = 1;
                    currentTab = _getTabForIndex(selectTab);
                  });
                },
              ),
              buildTabIcon(
                SvgPicture.asset(
                  'assets/svg/home_trainer.svg',
                  color: selectTab == 2 ? TColor.secondaryColor2 : Colors.grey,
                  width: 28,
                  height: 28,
                ),
                selectTab == 2,
                () {
                  setState(() {
                    selectTab = 2;
                    currentTab = _getTabForIndex(selectTab);
                  });
                },
              ),
              buildTabIcon(
                Icon(
                  Icons.calendar_month,
                  color: selectTab == 3 ? TColor.secondaryColor2 : Colors.grey,
                ),
                selectTab == 3,
                () {
                  setState(() {
                    selectTab = 3;
                    currentTab = _getTabForIndex(selectTab);
                  });
                },
              ),
              buildTabIcon(
                Icon(
                  Icons.person,
                  color: selectTab == 4 ? TColor.secondaryColor2 : Colors.grey,
                ),
                selectTab == 4,
                () {
                  setState(() {
                    selectTab = 4;
                    currentTab = _getTabForIndex(selectTab);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
