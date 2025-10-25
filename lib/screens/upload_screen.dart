import 'package:flutter/material.dart';
import '../widgets/lychee_scaffold.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LycheeScaffold(
      title: 'Lychee::Upload',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.upload_file, size: 80),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: 파일 업로드 로직 추가 예정
              },
              child: const Text('파일 업로드'),
            ),
          ],
        ),
      ),
    );
  }
}
