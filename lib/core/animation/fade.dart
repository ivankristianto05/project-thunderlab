import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  FadePageRoute({required this.builder})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          transitionDuration:
              Duration(milliseconds: 210), // Adjust the duration here
        );
}
