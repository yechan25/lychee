import 'package:flutter/material.dart';
import 'package:lychee/widgets/lychee_scaffold.dart';
import 'package:lychee/widgets/infinite_gridview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LycheeScaffold(title: "Lychee", body: InfiniteGridView());
  }
}
