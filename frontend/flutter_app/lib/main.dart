import 'package:flutter/material.dart';
import 'theme.dart';
import 'router.dart';

void main() => runApp(const ExameXApp());

class ExameXApp extends StatelessWidget {
  const ExameXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ExameX Mobile',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      onGenerateRoute: generateRoute,
      initialRoute: '/home',
    );
  }
}