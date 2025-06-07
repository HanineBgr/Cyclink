import 'package:fast_rhino/view/planning/planning_screen.dart';
import 'package:flutter/material.dart';
import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/view/Workout/workout_library.dart';
import 'package:fast_rhino/view/home/home_view.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fast_rhino/view/profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  final int initialTabIndex;

  const MainTabView({super.key, this.initialTabIndex = 0});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  late Widget currentTab;

  @override
  void initState() {
    super.initState();
    selectTab = widget.initialTabIndex;
    currentTab = _getTabForIndex(selectTab);
  }

  Widget _getTabForIndex(int index) {
    switch (index) {
      case 0:
        return const HomeViewScreen();
      case 1:
        return WorkoutLibrary();
      case 2:
        return const PlanningScreen();
      case 3:
        return ProfileView();
     
      default:
        return const HomeViewScreen();
    }
  }

  Widget buildTabItem({required Widget icon, required String label, required bool isActive, required VoidCallback onTap}) {
    final color = isActive ? TColor.primaryColor1 : Colors.grey;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectTab,
        height: 50.0,
        backgroundColor: Colors.transparent,
        color: TColor.primaryColor1,
        buttonBackgroundColor: TColor.primaryColor1,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.list_rounded, size: 30, color: Colors.white),
          Icon(Icons.calendar_month, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            selectTab = index;
            currentTab = _getTabForIndex(selectTab);
          });
        },
      ),
    );
  }
}
