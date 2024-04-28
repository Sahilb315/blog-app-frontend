// ignore_for_file: depend_on_referenced_packages, unused_field
import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/features/home/home_provider.dart';
import 'package:blog_app/features/home/ui/add_blog_page.dart';
import 'package:blog_app/features/home/ui/widgets/blog_tile.dart';
import 'package:blog_app/features/profile/ui/profile_page.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/helper_functions.dart';
import '../../../constants/error_handler.dart';
import '../../auth/ui/login_page.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  final String userToken;
  const HomePage({super.key, required this.userToken});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserTokenModel userTokenModel;
  late SharedPreferences _prefs;

  Future<void> initSharedPref() async {
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(widget.userToken);
    userTokenModel = UserTokenModel.fromMap(jwtDecoded);
    _prefs = await SharedPreferences.getInstance();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    initSharedPref();
    Provider.of<HomeProvider>(context, listen: false).fetchAllBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
        leading: const Icon(Icons.menu),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ProfilePage(
                  userTokenModel: userTokenModel,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(1.0, 0.0);
                  var end = Offset.zero;
                  var curve = Curves.easeIn;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                radius: 18,
                foregroundImage: NetworkImage(userTokenModel.profilePic),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToScreenDownToUpAni(
          context,
          AddNewBlogPage(
            userTokenModel: userTokenModel,
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.pencil_outline),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300.withOpacity(0.9),
              highlightColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, ${userTokenModel.username}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "Let's explore today",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(13),
                              height: 180,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      color: Colors.red,
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (provider.errorMessage != null) {
            return ErrorHandler(
              errorMessage: provider.errorMessage!,
            );
          } else {
            final blogs = provider.blogs;
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ${userTokenModel.username}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "Let's explore today",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: blogs.length,
                      itemBuilder: (context, index) {
                        final blog = blogs[index];
                        DateTime formattedDate = formatISODate(blog.createdAt!);
                        final gap = DateTime.now().difference(formattedDate);
                        return BlogTile(blog: blog, gap: gap);
                      },
                    ),
                    // SignOutButton(prefs: _prefs)
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


class SignOutButton extends StatelessWidget {
  const SignOutButton({
    super.key,
    required SharedPreferences prefs,
  }) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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
    );
  }
}
