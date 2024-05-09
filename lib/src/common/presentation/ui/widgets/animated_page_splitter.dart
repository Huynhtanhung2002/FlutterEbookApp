import 'package:flutter/material.dart';

class AnimatedPageSplitter extends StatelessWidget {
  final Widget leftChild;
  final Widget? rightChild;
  final bool isExpanded;
  final Duration animationDuration;
  final double dividerWidth;

  const AnimatedPageSplitter({
    super.key,
    required this.leftChild,
    this.rightChild,
    this.isExpanded = false,
    this.animationDuration = const Duration(milliseconds: 250),
    this.dividerWidth = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth; // Chiều rộng hiện tại của màn hình
        final firstHalfWidth = (screenWidth - dividerWidth) / 2.7; // Kích thước của phần bên trái
        final secondHalfWidth = screenWidth - firstHalfWidth; // Kích thước của phần bên phải

        // Tính toán kích thước của hai phần chia và đường phân chia
        final leftSectionWidth = isExpanded ? firstHalfWidth : screenWidth;
        final rightSectionWidth = isExpanded ? secondHalfWidth : 0.0;
        final animatedDividerWidth = isExpanded ? dividerWidth : 0.0;

        return Row(
          children: [
            // Phần bên trái
            AnimatedContainer(
              duration: animationDuration,
              width: leftSectionWidth,
              child: leftChild,
            ),
            // Đường phân chia
            AnimatedContainer(
              duration: animationDuration,
              width: animatedDividerWidth,
              color: Colors.transparent,
              child: animatedDividerWidth > 0 ? const VerticalDivider() : null,
            ),
            // Phần bên phải
            Expanded(
              child: AnimatedContainer(
                duration: animationDuration,
                width: rightSectionWidth,
                child: rightChild,
              ),
            ),
          ],
        );
      },
    );
  }
}
