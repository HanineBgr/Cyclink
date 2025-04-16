import 'package:flutter/material.dart';
import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/common_widget/round_button.dart';
import 'package:fast_rhino/common_widget/round_textfield.dart';
import 'package:fast_rhino/view/auth/signUp1.dart';
import 'package:fast_rhino/view/home/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isCheck = false;
  bool _isPasswordVisible = false; 

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(color: TColor.primaryColor1, fontSize: 13),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height * 0.9,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
                Text("Sign up or Login to your Account",
                    style: TextStyle(color: TColor.gray, fontSize: 16)),

                SizedBox(height: media.width * 0.05),

                buildLabel("Email"),
                RoundTextField(
                  hitText: "Enter your email",
                  icon: "assets/img/email.png",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: media.width * 0.04),

                buildLabel("Password"),
                RoundTextField(
                  hitText: "Enter your password",
                  icon: "assets/img/lock.png",
                  obscureText: !_isPasswordVisible, // 👈 control visibility
                  controller: passwordController,
                  rigtIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: TColor.gray,
                      size: 20,
                    ),
                  ),
                ),

                SizedBox(height: media.width * 0.01),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot your password?",
                        style: TextStyle(
                            color: TColor.gray,
                            fontSize: 12,
                            decoration: TextDecoration.underline)),
                  ],
                ),
                SizedBox(height: media.width * 0.08),

                RoundButton(
                  title: "Login",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeViewScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: media.width * 0.04),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.gray.withOpacity(0.5),
                      ),
                    ),
                    Text("  Or  ",
                        style: TextStyle(color: TColor.black, fontSize: 12)),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: TColor.gray.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: media.width * 0.04),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      //onTap: signInWithGoogle,
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                              width: 1, color: TColor.gray.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/google.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: media.width * 0.04),
                    GestureDetector(
                      onTap: () {
                        // Future: Add Strava logic
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TColor.white,
                          border: Border.all(
                              width: 1, color: TColor.gray.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.asset(
                          "assets/img/strava_logo.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(height: media.width * 0.04),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpView(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account yet?",
                          style: TextStyle(color: TColor.black, fontSize: 14)),
                      Text(" Register",
                          style: TextStyle(
                              color: TColor.secondaryColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.w700))
                    ],
                  ),
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
