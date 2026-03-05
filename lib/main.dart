import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/auth/auth_page.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Mind',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: AuthPage(),
    );
  }
}
