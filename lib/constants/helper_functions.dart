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

void navigateToScreenDownToUpAni(BuildContext context, Widget screen) {
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
        return "${time.inDays}d";
      }
      return "${time.inHours}h";
    }
    return "${time.inMinutes}m";
  } else {
    return "Just now";
  }
}

String calculateDate(String date) {
  final splitDate = date.split('-');
  final month = splitDate[1];
  switch (month) {
    case "01":
      return "${splitDate[2]} Jan ${splitDate[0]}";
    case "02":
      return "${splitDate[2]} Feb ${splitDate[0]}";
    case "03":
      return "${splitDate[2]} Mar ${splitDate[0]}";
    case "04":
      return "${splitDate[2]} Apr ${splitDate[0]}";
    case "05":
      return "${splitDate[2]} May ${splitDate[0]}";
    case "06":
      return "${splitDate[2]} June ${splitDate[0]}";
    case "07":
      return "${splitDate[2]} July ${splitDate[0]}";
    case "08":
      return "${splitDate[2]} Aug ${splitDate[0]}";
    case "09":
      return "${splitDate[2]} Sep ${splitDate[0]}";
    case "10":
      return "${splitDate[2]} Oct ${splitDate[0]}";
    case "11":
      return "${splitDate[2]} Nov ${splitDate[0]}";
    case "12":
      return "${splitDate[2]} Dec ${splitDate[0]}";
    default:
      return date;
  }
}
