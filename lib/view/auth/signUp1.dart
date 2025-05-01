import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/common_widget/round_button.dart';
import 'package:fast_rhino/common_widget/round_textfield.dart';
import 'package:fast_rhino/view/auth/signUp2.dart';
import 'package:fast_rhino/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isCheck = false;
  bool _isPasswordVisible = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedGender;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SignUp2Screen(
                  name: '',
                  email: '',
                  password: '',
                  gender: '',
                )),
      );
    } catch (e) {
      print('Erreur Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la connexion avec Google')),
      );
    }
  }

  void _validateAndContinue() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (!emailController.text.trim().contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SignUp2Screen(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          gender: selectedGender!,
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hey there,", style: TextStyle(color: TColor.gray, fontSize: 16)),
                Text("Create an Account",
                    style: TextStyle(color: TColor.black, fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: media.width * 0.05),
                RoundTextField(
                  hitText: "Full Name",
                  icon: "assets/img/user_text.png",
                  controller: nameController,
                ),
                SizedBox(height: media.width * 0.04),
                RoundTextField(
                  hitText: "Email",
                  icon: "assets/img/email.png",
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                SizedBox(height: media.width * 0.04),
                /// GENDER FIELD (styled like RoundTextField)
                Container(
                  decoration: BoxDecoration(
                    color: TColor.lightGray,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset(
                          "assets/img/choosegender.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: TColor.gray,
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGender,
                            isExpanded: true,
                            items: ["Male", "Female"]
                                .map((name) => DropdownMenuItem(
                                      value: name,
                                      child: Text(
                                        name,
                                        style: TextStyle(color: TColor.black, fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            hint: Text(
                              "Choose Gender",
                              style: TextStyle(color: TColor.gray, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.04),
                 RoundTextField(
                  hitText: "Enter your password",
                  icon: "assets/img/lock.png",
                  obscureText: !_isPasswordVisible,
                  controller: passwordController,
                  rigtIcon: IconButton(
                    onPressed: () {
                      setState(() => _isPasswordVisible = !_isPasswordVisible);
                    },
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: TColor.gray,
                      size: 20,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => isCheck = !isCheck),
                      icon: Icon(isCheck ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                          color: TColor.gray, size: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(color: TColor.gray, fontSize: 10)),
                    )
                  ],
                ),
                SizedBox(height: media.width * 0.04),
                RoundButton(
                  title: "Next >",
                  onPressed: _validateAndContinue,
                ),
                SizedBox(height: media.width * 0.02),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const LoginView()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: TColor.gray, fontSize: 14),
                      ),
                      Text(
                        "Login",
                        style: TextStyle(
                          color: TColor.secondaryColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
