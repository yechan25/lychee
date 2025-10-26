import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'upload_screen.dart';

class RootPager extends StatefulWidget {
  const RootPager({super.key});

  @override
  State<RootPager> createState() => _RootPagerState();
}

class _RootPagerState extends State<RootPager> {
  final PageController _controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: PageView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        children: [SearchScreen(), HomeScreen(), UploadScreen()],
      ),
    );
  }
}
