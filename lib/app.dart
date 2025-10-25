import 'package:flutter/material.dart';
import 'package:lychee/screens/root_pager.dart';

class LycheeApp extends StatelessWidget {
  const LycheeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lychee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xfff50057),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F9),
      ),
      home: const RootPager(),
    );
  }
}
