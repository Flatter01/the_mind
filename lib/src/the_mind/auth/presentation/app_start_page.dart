import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/auth/data/auth_repository.dart';
import 'package:srm/src/the_mind/auth/presentation/auth_page.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/nav_bar.dart';

class AppStartPage extends StatelessWidget {
  AppStartPage({super.key});

  final authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {

    if (authRepository.isLoggedIn) {
      return const WebCustomBottomNav();
    }

    return const AuthPage();
  }
}