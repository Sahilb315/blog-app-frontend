// ignore_for_file: depend_on_referenced_packages, unused_field, unrelated_type_equality_checks

import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/features/bookmarks/ui/bookmarks_page.dart';
import 'package:blog_app/features/home/provider/home_provider.dart';
import 'package:blog_app/features/home/ui/pages/add_blog_page.dart';
import 'package:blog_app/features/home/ui/widgets/blog_tile.dart';
import 'package:blog_app/features/home/ui/widgets/shimmer_loading.dart';
import 'package:blog_app/features/profile/ui/profile_page.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/helper_functions.dart';
import '../../../../constants/error_handler.dart';
import '../../../auth/ui/login_page.dart';

class HomePage extends StatefulWidget {
  final String userToken;
  const HomePage({super.key, required this.userToken});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserTokenModel userTokenModel;

  Future<void> initSharedPref() async {
    Map<String, dynamic> jwtDecoded = JwtDecoder.decode(widget.userToken);
    userTokenModel = UserTokenModel.fromMap(jwtDecoded);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    initSharedPref();
    Provider.of<HomeProvider>(context, listen: false)
        .fetchAllBlogs(userTokenModel.id);
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        context.read<HomeProvider>().setFloatingBtnVisible(false);
      } else {
        context.read<HomeProvider>().setFloatingBtnVisible(true);
      }
    });
    super.initState();
  }

  Future<void> onRefresh() async {
    Provider.of<HomeProvider>(context, listen: false)
        .fetchAllBlogs(userTokenModel.id);
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: appBgColor,

      /// Wait till the user info is fetched because it needs to display the the profile pic & till gives error
      /// if user is still fetching the user info
      drawer: context.read<HomeProvider>().isLoading
          ? const SizedBox.shrink()
          : Drawer(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.1,
                    ),
                    
                    /// User's Profile Data
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          foregroundImage: NetworkImage(
                            context.read<HomeProvider>().user!.profilePic,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          userTokenModel.username,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          userTokenModel.email,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    /// Page Tiles
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 48,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        ProfilePage(
                                  currentUserModel:
                                      context.watch<HomeProvider>().user!,
                                  otherUserModel:
                                      context.watch<HomeProvider>().user!,
                                  currentUserId: userTokenModel.id,
                                  userTokenModel: userTokenModel,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 12,
                              bottom: 12,
                              left: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.brown.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Iconsax.user_outline, color: Colors.white),
                                SizedBox(
                                  width: 24,
                                ),
                                Text(
                                  "Profile",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        BookmarksPage(
                                  userTokenModel: userTokenModel,
                                  currentUserModel:
                                      context.watch<HomeProvider>().user!,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 12,
                              bottom: 12,
                              left: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.brown.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Iconsax.bookmark_outline,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                Text(
                                  "Bookmarks",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        customCircularIndicator(context);
                        final prefs = await SharedPreferences.getInstance();
                        final result = await prefs.remove("token");
                        if (!context.mounted) return;

                        if (result == true) {
                          Navigator.popUntil(
                            context,
                            (route) => route == const LoginPage(),
                          );
                          Navigator.push(
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
                      child: Container(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                          left: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.brown.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Iconsax.logout_1_outline, color: Colors.black),
                            SizedBox(
                              width: 24,
                            ),
                            Text(
                              "Logout",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
        leading: InkWell(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: const Icon(Icons.menu),
        ),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: context.watch<HomeProvider>().isFloatingBtnVisible,
        child: FloatingActionButton(
          isExtended: true,
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
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingShimmerEffect(userTokenModel: userTokenModel);
          } else if (provider.errorMessage != null) {
            return ErrorHandler(
              errorMessage: provider.errorMessage!,
            );
          } else {
            final blogs = provider.blogs;
            final user = provider.user;
            return RefreshIndicator.adaptive(
              onRefresh: onRefresh,
              backgroundColor: Colors.white,
              color: Colors.brown,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  controller: scrollController,
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
                          DateTime formattedDate =
                              formatISODate(blog.createdAt!);
                          final gap = DateTime.now().difference(formattedDate);
                          return BlogTile(
                            currentUserModel: provider.user!,
                            currentUserId: userTokenModel.id,
                            blog: blog,
                            userTokenModel: userTokenModel,
                            gap: gap,
                            isBookmarked: user!.bookmarks.contains(blog.id),
                            onBookmarkTap: () {
                              provider.bookmarkBlog(
                                userId: userTokenModel.id,
                                blogModel: blog,
                                userTokenModel: userTokenModel,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({
//     super.key,
//     required this.userTokenModel,
//   });

//   final UserTokenModel userTokenModel;

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: MediaQuery.sizeOf(context).height * 0.1,
//             ),

//             /// User's Profile Data
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 40,
//                   foregroundImage: NetworkImage(userTokenModel.profilePic),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Text(
//                   userTokenModel.username,
//                   style: const TextStyle(
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   userTokenModel.email,
//                   style: TextStyle(
//                     color: Colors.grey.shade500,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),

//             /// Page Tiles
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const SizedBox(
//                   height: 48,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) =>
//                             ProfilePage(
//                           userTokenModel: userTokenModel,
//                         ),
//                         transitionsBuilder:
//                             (context, animation, secondaryAnimation, child) {
//                           var begin = const Offset(1.0, 0.0);
//                           var end = Offset.zero;
//                           var curve = Curves.easeInOut;
//                           var tween = Tween(begin: begin, end: end)
//                               .chain(CurveTween(curve: curve));

//                           return SlideTransition(
//                             position: animation.drive(tween),
//                             child: child,
//                           );
//                         },
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.only(
//                       top: 12,
//                       bottom: 12,
//                       left: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.brown.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(Iconsax.user_outline, color: Colors.white),
//                         SizedBox(
//                           width: 24,
//                         ),
//                         Text(
//                           "Profile",
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                     Navigator.push(
//                       context,
//                       PageRouteBuilder(
//                         pageBuilder: (context, animation, secondaryAnimation) =>
//                             BookmarksPage(userTokenModel: userTokenModel),
//                         transitionsBuilder:
//                             (context, animation, secondaryAnimation, child) {
//                           var begin = const Offset(1.0, 0.0);
//                           var end = Offset.zero;
//                           var curve = Curves.easeInOut;
//                           var tween = Tween(begin: begin, end: end)
//                               .chain(CurveTween(curve: curve));

//                           return SlideTransition(
//                             position: animation.drive(tween),
//                             child: child,
//                           );
//                         },
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.only(
//                       top: 12,
//                       bottom: 12,
//                       left: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.brown.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Iconsax.bookmark_outline,
//                           color: Colors.white,
//                         ),
//                         SizedBox(
//                           width: 24,
//                         ),
//                         Text(
//                           "Bookmarks",
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//               ],
//             ),
//             const Spacer(),
//             GestureDetector(
//               onTap: () async {
//                 customCircularIndicator(context);
//                 final prefs = await SharedPreferences.getInstance();
//                 final result = await prefs.remove("token");
//                 if (!context.mounted) return;

//                 if (result == true) {
//                   Navigator.popUntil(
//                     context,
//                     (route) => route == const LoginPage(),
//                   );
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const LoginPage(),
//                     ),
//                   );
//                 } else {
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Error while signing out'),
//                     ),
//                   );
//                 }
//               },
//               child: Container(
//                 padding: const EdgeInsets.only(
//                   top: 12,
//                   bottom: 12,
//                   left: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.brown.shade400),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Iconsax.logout_1_outline, color: Colors.black),
//                     SizedBox(
//                       width: 24,
//                     ),
//                     Text(
//                       "Logout",
//                       style: TextStyle(fontSize: 20, color: Colors.black),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
