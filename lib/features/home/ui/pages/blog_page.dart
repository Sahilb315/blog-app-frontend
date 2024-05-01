import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/constants/helper_functions.dart';
import 'package:blog_app/features/home/ui/pages/add_blog_page.dart';
import 'package:blog_app/models/blog_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPage extends StatefulWidget {
  final BlogModel blogModel;
  const BlogPage({super.key, required this.blogModel});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<String> matched = [];

  void getAllLinks(
    String name,
  ) {
    name.split("[").forEach((element) {
      if (element.contains("]")) {
        final pat = element.split(']')[0];
        matched.add(pat);
      }
    });
  }

  late List<String> words;

  @override
  void initState() {
    getAllLinks(widget.blogModel.content);
    words = widget.blogModel.content.split(" ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime formattedDate = formatISODate(widget.blogModel.createdAt!);
    // final gap = DateTime.now().difference(formattedDate);
    List splitDate = formattedDate.toString().split(' ');
    final date = splitDate[0];

    // final time = splitDate[1].toString().split('.').first;
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.blogModel.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    foregroundImage: NetworkImage(
                      widget.blogModel.createdBy!.profilePic,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.blogModel.createdBy!.username} • ",
                          ),
                          InkWell(
                            onTap: () {},
                            child: const Text(
                              "Follow",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(calculateDate(date.toString())),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: 200,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.blogModel.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                  ),
                  children: [
                    ...words.map(
                      (word) {
                        if (word.startsWith('[') && word.endsWith(']')) {
                          // log(word);
                          word.split("[").forEach((element) {
                            if (element.contains("]")) {
                              word = element.split(']')[0];
                            }
                          });
                        }
                        if (matched.contains(word)) {
                          return TextSpan(
                            text: "$word ",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                try {
                                  await launchUrl(Uri.parse("https://$word"));
                                } catch (e) {
                                  if (!context.mounted) return;
                                  displayToastMessage(context, e.toString());
                                }
                              },
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                          );
                        } else {
                          return TextSpan(
                            text: "$word ",
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
