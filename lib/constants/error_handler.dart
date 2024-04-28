import 'package:flutter/material.dart';

class ErrorHandler extends StatelessWidget {
  final String errorMessage;
  const ErrorHandler({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage.contains("SocketException")) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.grey.shade700,
              size: 64,
            ),
            const Text(
              "Please check your network connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
    } else if (errorMessage.contains("TimeoutException")) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.grey.shade700,
              size: 64,
            ),
            const Text(
              "Request timed out\nPlease try again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.grey.shade700,
              size: 64,
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      );
    }
  }
}
