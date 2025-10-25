import 'package:flutter/material.dart';
import '../widgets/lychee_scaffold.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LycheeScaffold(
      title: 'Lychee::Search',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            decoration: InputDecoration(
              hintText: '문제, 태그, 레시피 검색...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }
}
