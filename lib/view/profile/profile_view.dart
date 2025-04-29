import 'package:fast_rhino/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/profileCard.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';
import '../../common_widget/title_subtitle_cell.dart';
import '../../providers/auth_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    _saveLastScreen(); 
    Provider.of<AuthProvider>(context, listen: false).fetchUser();
  }

  Future<void> _saveLastScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastScreen', 'Profile');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text("Profile", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          InkWell(
            onTap: () async {
          await Provider.of<AuthProvider>(context, listen: false).signOut();
          Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: TColor.lightGray, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.logout, color: Colors.black, size: 20),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("assets/img/user.png", width: 50, height: 50, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name, style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500)),
                              Text(user.email, style: TextStyle(color: TColor.gray, fontSize: 12)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Edit",
                            type: RoundButtonType.bgGradient,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: TitleSubtitleCell(title: "${user.height}cm", subtitle: "Height")),
                        const SizedBox(width: 15),
                        Expanded(child: TitleSubtitleCell(title: "${user.weight}kg", subtitle: "Weight")),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TitleSubtitleCell(
                            title: "${calculateAge(user.dateOfBirth)}yo",
                            subtitle: "Age",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: TColor.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("General info", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          SettingRow(icon: "assets/img/p_personal.png", title: "Gender: ${user.gender}", onPressed: () {}),
                          SettingRow(icon: "assets/img/p_achi.png", title: "FTP: ${user.ftp}w", onPressed: () {}),
                          SettingRow(icon: "assets/img/p_activity.png", title: "Max HR: ${user.maxHR} bpm", onPressed: () {}),
                          SettingRow(icon: "assets/img/p_workout.png", title: "Resting HR: ${user.restingHR} bpm", onPressed: () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const ProfileCard(),
                  ],
                ),
              ),
            ),
    );
  }

  int calculateAge(DateTime? birthDate) {
    if (birthDate == null) return 0;
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
