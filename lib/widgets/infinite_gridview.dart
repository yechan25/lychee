import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lychee/widgets/problem_preview_card.dart';

class InfiniteGridView extends StatefulWidget {
  const InfiniteGridView({super.key});

  @override
  State<InfiniteGridView> createState() => _InfiniteGridViewState();
}

class _InfiniteGridViewState extends State<InfiniteGridView>
    with AutomaticKeepAliveClientMixin {
  static const _storageKey = PageStorageKey<String>('InfiniteGridViewKey');
  final ScrollController _controller = ScrollController(keepScrollOffset: true);

  final List<String> _problems = List.generate(40, (i) => '문제 ${i + 1}');
  static const double fixedCardHeight = 200.0;
  static const double _pixelsPerSecond = 20.0;

  bool _autoScrolling = false;
  bool _disposed = false;
  bool _userInteracting = false;
  Timer? _resumeTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScrollOnce();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    _controller.dispose();
    _resumeTimer?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  /// 자동 스크롤: 끝까지 부드럽게 내려가고 멈춤
  Future<void> _startAutoScrollOnce() async {
    if (_autoScrolling || !_controller.hasClients || _userInteracting) return;
    _autoScrolling = true;

    try {
      final position = _controller.position;
      final remaining = (position.maxScrollExtent - _controller.offset).clamp(
        0.0,
        double.infinity,
      );
      if (remaining <= 0) return;

      final seconds = (remaining / _pixelsPerSecond).clamp(5.0, 120.0);

      await _controller.animateTo(
        _controller.offset + remaining,
        duration: Duration(milliseconds: (seconds * 1000).toInt()),
        curve: Curves.linear,
      );
    } catch (_) {
      // 사용자가 스크롤 중이면 cancel 발생
    } finally {
      _autoScrolling = false;
    }
  }

  /// overscroll이 화면 높이의 10%를 넘으면 맨 위로 스르륵
  Future<void> _handleOverscroll(
    double overscroll,
    BuildContext context,
  ) async {
    if (!_controller.hasClients || _autoScrolling) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final triggerDistance = screenHeight * 0.10; // 화면 높이의 10%

    if (overscroll > triggerDistance) {
      await _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );

      // 맨 위로 올라간 후 자동 스크롤 재시작
      if (!_disposed) _startAutoScrollOnce();
    }
  }

  /// 사용자 스크롤 중 자동 스크롤 중단
  void _pauseAutoScrollTemporarily() {
    _userInteracting = true;
    _resumeTimer?.cancel();
  }

  /// 손 뗀 후 2초 뒤 자동 스크롤 재개
  void _scheduleAutoScrollResume() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      if (mounted && !_disposed) {
        _userInteracting = false;
        _startAutoScrollOnce();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final halfOffset = fixedCardHeight / 2.0;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          _pauseAutoScrollTemporarily();
        }

        if (notification is ScrollEndNotification) {
          _scheduleAutoScrollResume();
        }

        // 아래로 당겼을 때(overscroll > 0)
        if (notification is OverscrollNotification) {
          if (notification.overscroll > 0 &&
              notification.metrics.extentAfter == 0) {
            _handleOverscroll(notification.overscroll, context);
          }
        }

        return false;
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: MasonryGridView.builder(
          key: _storageKey,
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: _problems.length,
          itemBuilder: (context, index) {
            final title = _problems[index];
            final row = index ~/ 2;
            final isLeft = index.isEven;

            final card = SizedBox(
              height: fixedCardHeight,
              child: ProblemPreviewCard(
                title: title,
                onTap: () {},
                thumbnail: Container(
                  // ✅ Flutter 3.22+ 대응 (Color.withValues)
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.picture_as_pdf,
                    size: 36,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            );

            // 첫 줄의 왼쪽 카드만 반 높이 늦게 시작 → 지그재그 패턴 시드
            final bool offsetRight = row.isEven ? false : true;
            final bool shouldOffset =
                (offsetRight && !isLeft) || (!offsetRight && isLeft);

            if (shouldOffset && row == 0) {
              return Padding(
                padding: EdgeInsets.only(top: halfOffset),
                child: card,
              );
            }
            return card;
          },
        ),
      ),
    );
  }
}
