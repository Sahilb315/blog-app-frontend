// ignore_for_file: depend_on_referenced_packages, unused_field

import 'dart:developer';

import 'package:blog_app/constants/error_handler.dart';
import 'package:blog_app/features/auth/image_provider.dart';
import 'package:blog_app/features/auth/ui/login_page.dart';
import 'package:blog_app/features/bookmarks/bookmark_provider.dart';
import 'package:blog_app/features/home/provider/link_provider.dart';
import 'package:blog_app/features/home/provider/home_provider.dart';
import 'package:blog_app/features/home/ui/pages/home_page.dart';
import 'package:blog_app/features/profile/providers/profile_info_provider.dart';
import 'package:blog_app/features/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'features/auth/pass_visibility_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

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
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
        ChangeNotifierProvider(create: (context) => InfoProfileProvider()),
      ],
      child: MyApp(token: token),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Manage's network connectivity
  final Connectivity _connectivity = Connectivity();

  /// Stores the current connectivity status
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    log('Connectivity changed: $_connectionStatus');
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

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
        home: _connectionStatus.contains(ConnectivityResult.wifi) ||
                _connectionStatus.contains(ConnectivityResult.mobile)
            ? widget.token == null
                ? const LoginPage()
                : (JwtDecoder.isExpired(widget.token!))
                    ? const LoginPage()
                    : HomePage(
                        userToken: widget.token!,
                      )
            : const Scaffold(
                body: Center(
                  child: ErrorHandler(errorMessage: "SocketException"),
                ),
              ),
      );
    });
  }
}
