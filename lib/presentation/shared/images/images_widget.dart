import 'dart:ui';
import 'package:flutter/material.dart';

class _AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class ImagesWidget extends StatefulWidget {
  final List<String> images;
  final List<String> captions;
  final double height;

  const ImagesWidget({
    super.key,
    required this.images,
    this.captions = const [],
    this.height = 260,
  });

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    if (page < 0 || page >= widget.images.length) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported, size: 48),
    );
    final caption = _currentPage < widget.captions.length
        ? widget.captions[_currentPage]
        : '';
    final count = widget.images.length;

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: count == 0
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: placeholder,
                )
              : Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: _AppScrollBehavior(),
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: count,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.images[index],
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: scheme.surfaceContainerHighest,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (_, _, _) => placeholder,
                            ),
                          );
                        },
                      ),
                    ),
                    if (count > 1 && _currentPage > 0)
                      Positioned(
                        left: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton.filledTonal(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _goTo(_currentPage - 1),
                          ),
                        ),
                      ),
                    if (count > 1 && _currentPage < count - 1)
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: IconButton.filledTonal(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _goTo(_currentPage + 1),
                          ),
                        ),
                      ),
                  ],
                ),
        ),

        if (caption.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            caption,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],

        const SizedBox(height: 6),

        if (count > 1)
          count > 12
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_currentPage + 1} / $count',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    count,
                    (index) => InkWell(
                      onTap: () => _goTo(index),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 6,
                        ),
                        width: _currentPage == index ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? scheme.primary
                              : scheme.outlineVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
      ],
    );
  }
}
