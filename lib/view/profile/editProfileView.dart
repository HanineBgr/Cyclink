import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/common_widget/round_button.dart';
import 'package:fast_rhino/common_widget/round_textfield.dart';
import 'package:fast_rhino/models/user/user.dart';
import 'package:fast_rhino/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController ftpController;
  late TextEditingController maxHrController;
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    ftpController = TextEditingController();
    maxHrController = TextEditingController();
  }

 Future<void> _saveProfile() async {
  final success = await Provider.of<AuthProvider>(context, listen: false).updateUserProfile({
    'name': nameController.text.trim(),
    'email': emailController.text.trim(),
    'ftp': int.tryParse(ftpController.text.trim()),
    'max_hr': int.tryParse(maxHrController.text.trim()),
    'height': double.tryParse(heightController.text.trim()),
    'weight': double.tryParse(weightController.text.trim()),
  });

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Profile updated")));
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Failed to update")));
  }
}

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        elevation: 0,
        title: Text("Edit profile", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             Stack(
  alignment: Alignment.bottomRight,
  children: [
    DottedBorder(
      borderType: BorderType.Circle,
      color: TColor.primaryColor1,
      strokeWidth: 2,
      dashPattern: [6, 3],
      padding: const EdgeInsets.all(4),
      child: const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage("assets/img/user.png"),
      ),
    ),
    Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color(0xFFEAE6F8), // ✅ Soft purple background
          shape: BoxShape.circle,
       
        ),
        child: const Icon(Icons.edit, size: 18, color: Colors.black),
      ),
    ),
  ],
),

              const SizedBox(height: 20),
              RoundTextField(
                hitText: "Full Name: ${widget.user.name}",
                icon: "assets/img/user_text.png",
                controller: nameController,
              ),
              SizedBox(height: media.width * 0.04),
              RoundTextField(
                hitText: "Email: ${widget.user.email}",
                icon: "assets/img/email.png",
                controller: emailController,
              ),
              SizedBox(height: media.width * 0.04),
              
              RoundTextField(
                hitText: "FTP: ${widget.user.ftp} w",
                icon: "assets/img/energy.png",
                controller: ftpController,
              ),
              SizedBox(height: media.width * 0.04),
              RoundTextField(
                hitText: "Max HR: ${widget.user.maxHR} bpm",
                icon: "assets/img/heart.png",
                controller: maxHrController,
              ),
              SizedBox(height: media.width * 0.04),
              RoundTextField(
                hitText: "Change Password",
                icon: "assets/img/lock.png",
                obscureText: !_isPasswordVisible,
                controller: passwordController,
                rigtIcon: IconButton(
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: TColor.gray,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: media.width * 0.08),
              RoundButton(title: "Save Changes", onPressed: _saveProfile),
              SizedBox(height: media.width * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
