// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/helper_functions.dart';
import '../../auth/ui/login_page.dart';

class HomePage extends StatefulWidget {
  final String userToken;
  const HomePage({super.key, required this.userToken});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;
  String? email;

  late SharedPreferences _prefs;

  Future<void> initSharedPref() async {
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(widget.userToken);
    username = jwtDecoded['username'];
    email = jwtDecoded['email'];
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Username $username"),
            Text("Email $email"),
            ElevatedButton(
              onPressed: () async {
                customCircularIndicator(context);
                final result = await _prefs.remove("token");
                if (!context.mounted) return;

                if (result == true) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error while signing out'),
                    ),
                  );
                }
              },
              child: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }
}
