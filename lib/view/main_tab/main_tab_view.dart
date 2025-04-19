import 'package:fast_rhino/view/planning/planning_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/view/Workout/workout_library.dart';
import 'package:fast_rhino/view/home/home_view.dart';
import 'package:fast_rhino/view/profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();

  // 👇 This allows child widgets to access MainTabView's state
  static _MainTabViewState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainTabViewState>();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  late Widget currentTab;

  @override
  void initState() {
    super.initState();
    currentTab = const HomeViewScreen();
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
                    currentTab = const HomeViewScreen();
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
                    currentTab = WorkoutLibrary(eObj: {"name": "Workout Library"});
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
                    // Add any widget you want to show in tab 2
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
                    currentTab = PlanningScreen();
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
                    currentTab = const ProfileView();
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
