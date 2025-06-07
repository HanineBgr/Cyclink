import 'package:fast_rhino/services/auth/auth_service.dart';
import 'package:fast_rhino/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:fast_rhino/common/colo_extension.dart';
import 'package:fast_rhino/common_widget/round_button.dart';
import 'package:fast_rhino/common_widget/round_textfield.dart';
import 'package:fast_rhino/view/auth/signUp1.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isSignIn = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? _selectedGender;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }
    Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dateOfBirthController.text = picked.toIso8601String().split("T")[0];
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildToggleSwitch() {
    double toggleWidth = 260;
    double pillWidth = (toggleWidth - 8) / 2; // 8 for padding
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: toggleWidth,
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: _isSignIn ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: pillWidth,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8EC5FC), Color(0xFF6E8EF5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!_isSignIn) {
                      setState(() => _isSignIn = true);
                      _animationController.reverse();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 36,
                    child: Text(
                      "Sign in",
                      style: TextStyle(
                        color: _isSignIn ? Colors.white : const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_isSignIn) {
                      setState(() => _isSignIn = false);
                      _animationController.forward();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 36,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: !_isSignIn ? Colors.white : const Color(0xFFB0B0B0),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      key: const ValueKey('signup'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel("Full Name"),
        RoundTextField(
          hitText: "Enter your full name",
          icon: "assets/img/user_text.png",
          controller: fullNameController,
        ),
        const SizedBox(height: 16),
        buildLabel("Email"),
        RoundTextField(
          hitText: "Enter your email",
          icon: "assets/img/email.png",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        buildLabel("Date of birth"),
        GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: RoundTextField(
                      hitText: "Date of Birth (YYYY-MM-DD)",
                      icon: "assets/img/date.png",
                      controller: dateOfBirthController, 
                    ),
                  ),
                ),
                        const SizedBox(height: 16),

       buildLabel("Height"),
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
        const SizedBox(height: 16),
        buildLabel("Weight "),
        Row(
                  children: [
                    Expanded(
                      child: RoundTextField(
                        controller: heightController,
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
        const SizedBox(height: 20),
        RoundButton(
          title: "Sign up",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill all fields')),
            );
          },
        ),
      ],
    );
  }

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

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Static login logic
      if (email == 'bouguerrahanine4@gmail.com' && password == 'password123') {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainTabView()),
        );
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      String errorMessage = 'Login failed. Please try again.';
      if (e.toString().toLowerCase().contains('unauthorized') ||
          e.toString().toLowerCase().contains('401') ||
          e.toString().toLowerCase().contains('invalid')) {
        errorMessage = 'Incorrect email or password. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: TColor.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome", style: TextStyle(color: TColor.black, fontSize: 30, fontWeight: FontWeight.w700)),
              Text("Sign up or Login to your Account", style: TextStyle(color: TColor.gray, fontSize: 16)),
              _buildToggleSwitch(),
              SizedBox(height: media.width * 0.05),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSignIn
                    ? Column(
                        key: const ValueKey('signin'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          SizedBox(height: media.width * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Forgot your password?",
                                  style: TextStyle(color: TColor.gray, fontSize: 12, decoration: TextDecoration.underline)),
                            ],
                          ),
                          SizedBox(height: media.width * 0.08),
                          RoundButton(
                            title: "Login",
                            onPressed: _handleLogin,
                          ),
                          SizedBox(height: media.width * 0.04),
                          Row(
                            children: [
                              Expanded(child: Container(height: 1, color: TColor.gray.withOpacity(0.5))),
                              Text("  Or  ", style: TextStyle(color: TColor.black, fontSize: 12)),
                              Expanded(child: Container(height: 1, color: TColor.gray.withOpacity(0.5))),
                            ],
                          ),
                          SizedBox(height: media.width * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google button
                              GestureDetector(
                                onTap: () {},
                                child: _socialButton("assets/img/google.png"),
                              ),
                              SizedBox(width: media.width * 0.04),
                              // Strava button
                              GestureDetector(
                                onTap: () async {},
                                child: _socialButton("assets/img/strava_logo.png"),
                              ),
                            ],
                          ),
                        ],
                      )
                    : _buildSignUpForm(),
              ),
              SizedBox(height: media.width * 0.04),
              if (_isSignIn)
                TextButton(
                  onPressed: () {
                    setState(() => _isSignIn = false);
                    _animationController.forward();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account yet?", style: TextStyle(color: TColor.black, fontSize: 14)),
                      Text(" Register",
                          style: TextStyle(color: TColor.secondaryColor1, fontSize: 14, fontWeight: FontWeight.w700))
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: TColor.white,
        border: Border.all(width: 1, color: TColor.gray.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Image.asset(assetPath, width: 20, height: 20),
    );
  }
}
