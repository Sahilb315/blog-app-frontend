import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/features/home/ui/blog_page.dart';
import 'package:blog_app/models/blog_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class BlogTile extends StatelessWidget {
  const BlogTile({
    super.key,
    required this.blog,
    required this.gap,
  });

  final BlogModel blog;
  final Duration gap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                BlogPage(blogModel: blog),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.easeIn;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      blog.title,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 100,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          blog.thumbnail,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        foregroundImage: NetworkImage(
                          blog.createdBy!.profilePic,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "${blog.createdBy!.username}\n${calculateTimeGap(gap)}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(CupertinoIcons.bookmark),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
