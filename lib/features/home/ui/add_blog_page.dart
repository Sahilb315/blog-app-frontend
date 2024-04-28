// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:blog_app/constants/colors.dart';
import 'package:blog_app/features/auth/image_provider.dart';
import 'package:blog_app/features/home/ui/preview_page.dart';
import 'package:blog_app/models/blog_model.dart';
import 'package:blog_app/models/user_token_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:provider/provider.dart';

class AddNewBlogPage extends StatefulWidget {
  final UserTokenModel userTokenModel;
  const AddNewBlogPage({super.key, required this.userTokenModel});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();

  final contentController = TextEditingController();

  final linkController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> getImage(BuildContext context) async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (!context.mounted) return;
    if (pickedFile != null) {
      context.read<PickImageProvider>().setImageFile(File(pickedFile.path));
      context.read<PickImageProvider>().setDoesImageExist(true);
    } else {
      context.read<PickImageProvider>().setDoesImageExist(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: appBgColor,
        surfaceTintColor: appBgColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            FluentSystemIcons.ic_fluent_dismiss_regular,
            color: Colors.grey.shade700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {
                if (titleController.text.isEmpty) {
                  displayToastMessage(context, "Please add a title");
                } else if (!context.read<PickImageProvider>().doesImageExist) {
                  displayToastMessage(context, "Please add a thumbnail");
                } else if (contentController.text.isEmpty) {
                  displayToastMessage(context, "Please add content");
                } else {
                  final path = context
                      .read<PickImageProvider>()
                      .imageFile!
                      .path
                      .toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogPreviewPage(
                        linkController: linkController,
                        titleController: titleController,
                        contentController: contentController,
                        userId: widget.userTokenModel.id,
                        blogModel: BlogModel(
                          thumbnail: path,
                          title: titleController.text.trim(),
                          content: contentController.text.trim(),
                          links: [],
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade500.withOpacity(0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: const Text(
                  "Preview",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.only(left: 12, bottom: 8, top: 2),
        height: 45,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: appBgColor,
          border: Border(
            top: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                linkAdderDialog(
                  context,
                  () {
                    if (linkController.text.isEmpty) {
                      return;
                    }
                    contentController.text += "[${linkController.text}]";
                    linkController.clear();
                    Navigator.pop(context);
                  },
                );
              },
              child: Icon(
                CupertinoIcons.link,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Consumer<PickImageProvider>(
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () => getImage(context),
                        borderRadius: BorderRadius.circular(10),
                        child: value.doesImageExist
                            ? Container(
                                height: 150,
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(value.imageFile!),
                                  ),
                                  border:
                                      Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )
                            : Container(
                                height: 150,
                                width: MediaQuery.sizeOf(context).width * 0.9,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Upload Thumbnail"),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Icon(
                                        CupertinoIcons.photo,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    smartDashesType: SmartDashesType.enabled,
                    smartQuotesType: SmartQuotesType.enabled,
                    autofocus: true,
                    controller: titleController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(fontSize: 22),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(2),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: contentController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Content',
                      hintStyle: TextStyle(fontSize: 18),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(2),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> linkAdderDialog(BuildContext context, void Function() onTap) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: appBgColor,
          title: const Text(
            "Add a link",
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  hintText: "https://",
                  hintStyle: TextStyle(
                    color: Colors.brown,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

ToastificationItem displayToastMessage(BuildContext context, String message) {
  return toastification.show(
    context: context,
    backgroundColor: Colors.red,
    dismissDirection: DismissDirection.horizontal,
    foregroundColor: Colors.white,
    primaryColor: Colors.red,
    showProgressBar: false,
    type: ToastificationType.warning,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(milliseconds: 2500),
    title: Text(message),
  );
}
