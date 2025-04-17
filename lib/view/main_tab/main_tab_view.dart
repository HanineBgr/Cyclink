import 'package:flutter/material.dart';
import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/view/Workout/workout_library.dart';
import 'package:fast_rhino/view/bluetooth/bluetooth_screen.dart';
import '../Workout/sessionSummary.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

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
    currentTab = const HomeViewScreen();
  }

  Widget buildTabIcon(IconData icon, bool isActive, VoidCallback onTap) {
    return IconButton(
      icon: Icon(
        icon,
        color: isActive ? TColor.secondaryColor2 : Colors.grey,
      ),
      onPressed: onTap,
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
              buildTabIcon(Icons.home, selectTab == 0, () {
                setState(() {
                  selectTab = 0;
                  currentTab = const HomeViewScreen();
                });
              }),
              buildTabIcon(Icons.directions_bike, selectTab == 1, () {
                setState(() {
                  selectTab = 1;
                  currentTab = WorkoutLibrary(eObj: {"name": "Workout Library"});
                });
              }),
              buildTabIcon(Icons.bluetooth, selectTab == 2, () {
                setState(() {
                  selectTab = 2;
                  currentTab =  BluetoothScreen();
                });
              }),
              buildTabIcon(Icons.bar_chart, selectTab == 3, () {
                setState(() {
                  selectTab = 3;
                  currentTab = SessionSummaryScreen(eObj: {"name": "Training summary"});
                });
              }),
              buildTabIcon(Icons.person, selectTab == 4, () {
                setState(() {
                  selectTab = 4;
                  currentTab = const ProfileView();
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}
