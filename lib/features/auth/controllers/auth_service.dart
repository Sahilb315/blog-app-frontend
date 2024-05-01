// ignore_for_file: depend_on_referenced_packages

import 'package:blog_app/features/auth/controllers/auth_controller.dart';
import 'package:blog_app/features/auth/image_provider.dart';
import 'package:blog_app/features/auth/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/helper_functions.dart';
import '../../../models/user_model.dart';
import '../../home/ui/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static void signUpUser(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    customCircularIndicator(context);
    if (!context.read<PickImageProvider>().doesImageExist) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter profile pic"),
        ),
      );
      return;
    }
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
    if (passwordController.text.length < 6) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters"),
        ),
      );
      return;
    }
    final emailValidChecker =
        RegExp("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,64}");
    final isValidEmail = emailValidChecker.hasMatch(emailController.text);
    if (!isValidEmail) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid email"),
        ),
      );
      return;
    }
    final result = await AuthController.signUpUser(
      UserModel(
        profilePic: context.read<PickImageProvider>().imageFile!.path,
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        followers: [],
        following: [],
        bookmarks: [],
      ),
    );
    if (!context.mounted) return;

    if (result == null) {
      Navigator.pop(context);
      navigateToScreenReplaceRightLeftAnimation(
        context,
        const LoginPage(),
      );
      context.read<PickImageProvider>().clearAll();
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

  static void loginUser(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      SharedPreferences prefs) async {
    customCircularIndicator(context);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
      return;
    }
    final result = await AuthController.loginUser(
      emailController.text.trim(),
      passwordController.text,
    );
    if (!context.mounted) return;

    if (result != null) {
      if (result == "User not found") {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No user found \nPlease create a account"),
          ),
        );
      } else if (result == "Invalid password") {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Invalid Password"),
          ),
        );
      } else {
        final userToken = result;
        prefs.setString("token", userToken);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userToken: userToken),
          ),
        );
      }
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Some error occured \nPlease try again later"),
        ),
      );
    }
  }
}
