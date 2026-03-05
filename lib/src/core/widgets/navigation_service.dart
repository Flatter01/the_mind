import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future push(Widget page) {
    return navigatorKey.currentState!
        .push(MaterialPageRoute(builder: (_) => page));
  }

  static void pop() {
    final nav = navigatorKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }

  static bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
}