import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ReadSpeed logo mark: stylized "R" merged with an open book + speed lines.
/// Built in code so it can be swapped 1:1 for the supplied brand asset
/// (drop a PNG/SVG into assets/ and replace the child of [ReadSpeedLogo]).
class ReadSpeedLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;

  const ReadSpeedLogo({super.key, this.size = 56, this.showWordmark = false});

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.greenBright, AppColors.greenMuted],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4022E06F),
            blurRadius: 20,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.menu_book_rounded,
              size: size * 0.52, color: Colors.black.withOpacity(0.85)),
          Positioned(
            right: size * 0.14,
            bottom: size * 0.16,
            child: Icon(Icons.bolt_rounded,
                size: size * 0.34, color: Colors.black.withOpacity(0.9)),
          ),
        ],
      ),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.28),
        Text(
          'ReadSpeed',
          style: TextStyle(
            fontSize: size * 0.42,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
