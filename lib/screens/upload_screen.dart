import 'package:flutter/material.dart';
import 'package:lychee/widgets/lychee_scaffold.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final List<String> typeList = ['문제', '풀이', '첨삭'];
  final List<String> tagOptions = ['김백진선생님', '강향임선생님', '길승호선생님'];
  final List<String> selectedTags = [];

  final TextEditingController _timeController = TextEditingController();
  String? warningText;

  String? selectedType;
  String? selectedTag;

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  void _validateTime(String value) {
    if (value.isEmpty) {
      setState(() => warningText = null);
      return;
    }
    if (int.tryParse(value) == null) {
      setState(() => warningText = '숫자만 입력 가능합니다.');
    } else {
      setState(() => warningText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LycheeScaffold(
      title: 'Lychee::Upload',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: '출제자 이름',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            initialValue: selectedType,
            decoration: const InputDecoration(
              labelText: '유형',
              border: OutlineInputBorder(),
            ),
            items: typeList
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: (v) => setState(() => selectedType = v),
          ),
          const SizedBox(height: 16),

          // 업로드 영역
          SizedBox(
            height: 480,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: const Center(child: Text('파일 업로드 영역')),
            ),
          ),
          const SizedBox(height: 16),

          // 태그 칩들 (횡으로 계속 늘어남)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedTags.map((tag) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close),
                    onDeleted: () => setState(() => selectedTags.remove(tag)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // 태그 추가 드롭다운
          DropdownButtonFormField<String>(
            initialValue: selectedTag,
            decoration: const InputDecoration(
              labelText: '태그 추가',
              border: OutlineInputBorder(),
            ),
            items: tagOptions
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (t) {
              if (t != null) {
                setState(() {
                  selectedTags.add(t);
                  selectedTag = null;
                });
              }
            },
          ),
          const SizedBox(height: 16),

          // 풀이 시간 입력 + 경고문
          TextField(
            controller: _timeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '풀이 시간',
              border: OutlineInputBorder(),
            ),
            onChanged: _validateTime,
          ),
          const SizedBox(height: 8),
          if (warningText != null)
            Text(
              warningText!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          const SizedBox(height: 24),

          // 리치색 완료 버튼
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary, // 리치색 (핑크레드)
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // 여기에 업로드 완료 로직 추가
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('업로드 완료!')));
              },
              child: const Text('완료', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
