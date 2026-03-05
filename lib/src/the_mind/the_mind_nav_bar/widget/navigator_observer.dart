import 'package:flutter/material.dart';

class InnerPushObserver extends NavigatorObserver {
  final VoidCallback onPush;

  InnerPushObserver({required this.onPush});

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    onPush(); // вызываем коллбек при любом push
  }
}
