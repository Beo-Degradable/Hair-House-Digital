import 'package:flutter/material.dart';
import 'dart:ui';

class PromoGallery extends StatefulWidget {
  final List<String> promoImages; // List of image asset paths

  PromoGallery({required this.promoImages});

  @override
  _PromoGalleryState createState() => _PromoGalleryState();
}

class _PromoGalleryState extends State<PromoGallery> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 0.6,
      initialPage:
          1, // Start from first real item (index 1 due to +2 items logic)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    _controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _prevPage() {
    _controller.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.promoImages.length + 2, // +2 for looping
            onPageChanged: (index) {
              setState(() {
                if (index == 0) {
                  _currentPage = widget.promoImages.length - 1;
                  _controller.jumpToPage(widget.promoImages.length);
                } else if (index == widget.promoImages.length + 1) {
                  _currentPage = 0;
                  _controller.jumpToPage(1);
                } else {
                  _currentPage = index - 1;
                }
              });
            },
            itemBuilder: (context, index) {
              int displayIndex;
              if (index == 0) {
                displayIndex =
                    widget.promoImages.length - 1; // last image for left loop
              } else if (index == widget.promoImages.length + 1) {
                displayIndex = 0; // first image for right loop
              } else {
                displayIndex = index - 1;
              }

              double scale = displayIndex == _currentPage ? 1.0 : 0.7;
              bool isSide = displayIndex != _currentPage;

              return Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Transform.scale(
                    scale: scale,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: isSide
                          ? ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                              child: Image.asset(
                                widget.promoImages[displayIndex],
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              widget.promoImages[displayIndex],
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Left button
          Positioned(
            left: 0,
            child: IconButton(
              icon: Icon(Icons.chevron_left, size: 32),
              color: Colors.white,
              onPressed: _prevPage,
            ),
          ),
          // Right button
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.chevron_right, size: 32),
              color: Colors.white,
              onPressed: _nextPage,
            ),
          ),
        ],
      ),
    );
  }
}
