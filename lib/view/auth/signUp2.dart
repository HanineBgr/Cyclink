import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/common_widget/round_button.dart';
import 'package:fast_rhino/common_widget/round_textfield.dart';
import 'package:fast_rhino/provider/auth_provider.dart';
import 'package:fast_rhino/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp2Screen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String gender;

  const SignUp2Screen({
    Key? key,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
  }) : super(key: key);

  @override
  State<SignUp2Screen> createState() => _SignUp2ScreenState();
}

class _SignUp2ScreenState extends State<SignUp2Screen> {
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ftpController = TextEditingController();


  bool isLoading = false;
  String? errorMessage;

 Future<void> showSuccessDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 26),
          SizedBox(width: 8),
          Text("Account Created"),
        ],
      ),
      content: const Text(
        "Your account has been created successfully!",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginView()),
            );
          },
          child: const Text("OK", style: TextStyle(fontSize: 14)),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Image.asset(
                  "assets/img/complete_profile.png",
                  width: media.width,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: media.width * 0.05),
                Text("Let’s complete your profile",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                Text("It will help us to know more about you!",
                    style: TextStyle(color: TColor.gray, fontSize: 12)),
                SizedBox(height: media.width * 0.05),

                /// DATE OF BIRTH
                RoundTextField(
                  hitText: "Date of Birth (YYYY-MM-DD)",
                  icon: "assets/img/date.png",
                  controller: dateOfBirthController,
                ),
                SizedBox(height: media.width * 0.04),

                /// WEIGHT
                Row(
                  children: [
                    Expanded(
                      child: RoundTextField(
                        controller: weightController,
                        hitText: "Your Weight",
                        icon: "assets/img/weight.png",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.secondaryG),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("KG", style: TextStyle(color: TColor.white, fontSize: 12)),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.04),

                /// HEIGHT
                Row(
                  children: [
                    Expanded(
                      child: RoundTextField(
                        controller: heightController,
                        hitText: "Your Height",
                        icon: "assets/img/hight.png",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.secondaryG),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text("CM", style: TextStyle(color: TColor.white, fontSize: 12)),
                    ),
                  ],
                ),
                SizedBox(height: media.width * 0.04),

                /// FTP
                RoundTextField(
                  hitText: "FTP",
                  icon: "assets/img/energy.png",
                  controller: ftpController,
                  keyboardType: TextInputType.number,
                ),
            
                SizedBox(height: media.width * 0.04),

                /// Error
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14)),
                  ),

                /// Button
                isLoading
                    ? const CircularProgressIndicator()
                    : RoundButton(
                        title: "Register",
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          try {
                            final DateTime dob =
                                DateTime.parse(dateOfBirthController.text.trim());
                            final double weight =
                                double.parse(weightController.text.trim());
                            final double height =
                                double.parse(heightController.text.trim());
                            final int ftp = int.parse(ftpController.text.trim());

                            await authProvider.signUp(
                              email: widget.email,
                              name: widget.name,
                              password: widget.password,
                              gender: widget.gender,
                              dateOfBirth: dob,
                              weight: weight,
                              height: height,
                              ftp: ftp,                           
                              preferences: {},
                            );

                            await showSuccessDialog(context);
                          } catch (e) {
                            setState(() {
                              errorMessage = e.toString().replaceAll('Exception: ', '');
                            });
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                SizedBox(height: media.width * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
