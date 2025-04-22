import 'package:fast_rhino/common_widget/tss_chart.dart';
import 'package:fast_rhino/providers/auth_provider.dart';
import 'package:fast_rhino/view/main_tab/main_tab_view.dart';
import 'package:fast_rhino/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/performance_chart.dart';
import '../../common_widget/recent_activities.dart';
import '../../common_widget/training_status.dart';

class HomeViewScreen extends StatelessWidget {
  const HomeViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user?.name ?? 'Rhino boss';

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingValue = screenWidth * 0.05;
    double maxWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            _buildHeader(context, userName),
            SizedBox(height: screenHeight * 0.02),
            _buildCenteredWidget(TrainingStatus(), maxWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildCenteredWidget(PerformanceChart(), maxWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildCenteredWidget(TssChart(), maxWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildCenteredWidget(
              const Text(
                'Recent Activities',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              maxWidth,
            ),
            _buildCenteredWidget(
              RecentActivities(
                activityName: 'Cycling - 30 km',
                activityDate: 'Tuesday 01 pm',
                buttonColor: Color.fromARGB(255, 245, 235, 221),
                buttonLabel: 'Strava',
                textColor: Colors.orange,
                activityIcon: Icons.directions_bike_sharp,
              ),
              maxWidth,
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildCenteredWidget(
              RecentActivities(
                activityName: 'Swimming',
                activityDate: 'Monday 10 am',
                buttonColor: Color.fromARGB(255, 232, 231, 228),
                buttonLabel: 'App',
                textColor: Colors.black54,
                activityIcon: Icons.pool,
              ),
              maxWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredWidget(Widget child, double maxWidth) {
    return Center(
      child: SizedBox(
        width: maxWidth,
        child: child,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return ListTile(
      leading: GestureDetector(
        onTap: () async {
          await _saveLastScreen(); // ✅ Sauvegarde avant d'aller au profil
          MainTabView.of(context)?.setState(() {
            MainTabView.of(context)!.selectTab = 4;
            MainTabView.of(context)!.currentTab = const ProfileView();
          });
        },
        child: const CircleAvatar(
          backgroundImage: AssetImage('assets/img/user.png'),
          backgroundColor: Color.fromARGB(0, 255, 244, 244),
        ),
      ),
      title: Text(
        'Welcome $userName!',
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _saveLastScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'HomeView');
  }
}
