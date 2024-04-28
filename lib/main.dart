// ignore_for_file: depend_on_referenced_packages

import 'package:blog_app/features/auth/image_provider.dart';
import 'package:blog_app/features/auth/ui/login_page.dart';
import 'package:blog_app/features/home/link_provider.dart';
import 'package:blog_app/features/home/home_provider.dart';
import 'package:blog_app/features/home/ui/home_page.dart';
import 'package:blog_app/features/profile/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/pass_visibility_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final token = preferences.getString("token");
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TogglePasswordVisibility()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => PickImageProvider()),
        ChangeNotifierProvider(create: (context) => LinkProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: MyApp(token: token),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Poppins',
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.brown.shade100,
            cursorColor: Colors.brown,
          ),
        ),
        home: token == null
            ? const LoginPage()
            : (JwtDecoder.isExpired(token!))
                ? const LoginPage()
                : HomePage(
                    userToken: token!,
                  ),
      );
    });
  }
}
