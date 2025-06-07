import 'package:fast_rhino/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import '../../common/colo_extension.dart';
import '../../common_widget/profileCard.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Static user data
  final String userName = "Hanine";
  final String userEmail = "bouguerrahanine4@gmail.com";
  final String userGender = "Female";
  final int userFTP = 250;
  final int userMaxHR = 180;
  final int userRestingHR = 60;
  final int userHeight = 175;
  final int userWeight = 70;
  final int userAge = 30;

  @override
  void initState() {
    super.initState();
  }

 

  @override
  Widget build(BuildContext context) {
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
              );
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
      body: SingleChildScrollView(
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
                        Text(userName, style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500)),
                        Text(userEmail, style: TextStyle(color: TColor.gray, fontSize: 12)),
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
                      onPressed: () {
                        // Handle edit button press
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SettingRow(icon: "assets/img/p_personal.png", title: "Gender: $userGender", onPressed: () {}),
                              SettingRow(icon: "assets/img/p_achi.png", title: "FTP: ${userFTP}w", onPressed: () {}),
                            
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: [
                                SettingRow(icon: "assets/img/p_activity.png", title: "Max HR: ${userMaxHR} bpm", onPressed: () {}),
                              SettingRow(icon: "assets/img/p_workout.png", title: "Resting HR: ${userRestingHR} bpm", onPressed: () {}),
                            ],
                          ),
                        ),
                      ],
                    ),
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
}
