// ignore_for_file: depend_on_referenced_packages

import 'package:blog_app/features/auth/controllers/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/textfield.dart';
import 'package:blog_app/constants/textStyle.dart';
import 'package:blog_app/features/auth/ui/signup_page.dart';
import 'package:blog_app/features/auth/pass_visibility_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          )),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.0,
                          right: 12,
                          top: MediaQuery.sizeOf(context).height * 0.08,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Login to your \naccount",
                              style: headingStyle.copyWith(
                                fontSize: 28,
                                color: Colors.brown.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/images/login.svg",
                              height: 110,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          height: MediaQuery.sizeOf(context).height * 0.65,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Email",
                                style: headingStyleSF.copyWith(
                                  color: Colors.brown.shade700,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SignUpTextField(
                                controller: emailController,
                                suffixIcon: Icon(
                                  CupertinoIcons.mail,
                                  color: Colors.brown.shade400,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Password",
                                style: headingStyleSF.copyWith(
                                  color: Colors.brown.shade700,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Consumer<TogglePasswordVisibility>(
                                builder: (context, value, child) {
                                  return TextField(
                                    controller: passwordController,
                                    obscureText: !(value.showPasswordLogin),
                                    cursorRadius: const Radius.circular(8),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 8,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          value.togglePasswordLogin();
                                        },
                                        child: Icon(
                                          value.showPasswordLogin
                                              ? CupertinoIcons.lock_open
                                              : CupertinoIcons.lock,
                                          color: Colors.brown.shade400,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.brown.shade300,
                                          width: 1.1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.brown.shade300,
                                          width: 1.1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.brown.shade300,
                                          width: 1.1,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              InkWell(
                                onTap: () => AuthService.loginUser(
                                  context,
                                  emailController,
                                  passwordController,
                                  _prefs,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.brown,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "Log In",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?"),
                                  InkWell(
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SignUpPage(),
                                      ),
                                    ),
                                    child: const Text(
                                      " Sign Up",
                                      style: TextStyle(color: Colors.brown),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
