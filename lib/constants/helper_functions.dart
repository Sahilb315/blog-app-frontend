import 'package:flutter/material.dart';

void navigateToScreenReplaceRightLeftAnimation(
    BuildContext context, Widget screen) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  );
}

void navigateToScreenDownToUpAni(BuildContext context, Widget screen){
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
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
  );
}

void customCircularIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Center(
      child: CircularProgressIndicator(
        color: Colors.brown,
        strokeWidth: 3,
        strokeCap: StrokeCap.round,
      ),
    ),
  );
}

DateTime formatISODate(String netUtcDate) {
  var dateParts = netUtcDate.split(".");
  var actualDate = DateTime.parse("${dateParts[0]}Z");
  return actualDate;
}

String calculateTimeGap(Duration time) {
  if (time.inSeconds > 60) {
    if (time.inMinutes > 60) {
      if (time.inHours > 24) {
        return "${time.inDays}d ${time.inHours - 24}h";
      }
      return "${time.inHours}h";
    }
    return "${time.inMinutes}m";
  } else {
    return "Just now";
  }
}
