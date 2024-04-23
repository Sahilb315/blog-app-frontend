import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/constants/textStyle.dart';
import 'package:blog_app/features/auth/controllers/auth_controller.dart';
import 'package:blog_app/features/auth/ui/login_page.dart';
import 'package:blog_app/features/auth/widgets/textfield.dart';
import 'package:blog_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../toggle_pass_visibility.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUpUser(BuildContext context) async {
    customCircularIndicator(context);
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
      return;
    }
    final result = await AuthController.signUpUser(
      UserModel(
        username: usernameController.text,
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
    if (!context.mounted) return;

    if (result == null) {
      Navigator.pop(context);
      navigateToScreenReplaceRightLeftAnimation(
        context,
        const LoginPage(),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                            left: 16.0,
                            top: MediaQuery.sizeOf(context).height * 0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Create an \naccount",
                              style: headingStyle.copyWith(
                                fontSize: 28,
                                color: Colors.brown.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SvgPicture.asset(
                              "assets/images/blog.svg",
                              height: 120,
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
                          height: MediaQuery.sizeOf(context).height * 0.7,
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
                              Text(
                                "Username",
                                style: headingStyleSF.copyWith(
                                  color: Colors.brown.shade700,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SignUpTextField(
                                controller: usernameController,
                                suffixIcon: Icon(
                                  CupertinoIcons.person,
                                  color: Colors.brown.shade400,
                                ),
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
                                builder: (context, value, child) => TextField(
                                  controller: passwordController,
                                  obscureText: !(value.showPasswordRegister),
                                  cursorRadius: const Radius.circular(8),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 8,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        value.togglePasswordRegister();
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
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              InkWell(
                                onTap: () => signUpUser(context),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.brown,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    "Create an account",
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
                                  const Text("Have an account?"),
                                  InkWell(
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    ),
                                    child: const Text(
                                      " Log in",
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
