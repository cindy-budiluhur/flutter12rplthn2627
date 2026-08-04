import 'package:flutter/material.dart';

class AnimatedLikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback? onTap;

  const AnimatedLikeButton({super.key, required this.isLiked, this.onTap});

  @override
  State<AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton> {
  double scale = 1.0;

  void _toggleLike() {
    setState(() {
      scale = 1.35;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        scale = 1.0;
      });
    });

    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          child: IconButton(
            icon: Icon(
              widget.isLiked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: widget.isLiked
                  ? const Color(0xFFFF4757)
                  : Colors.grey[400],
              size: 26,
            ),
            onPressed: _toggleLike,
          ),
        ),
        Text(
          '${widget.isLiked ? 1 : 0}',
          style: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
