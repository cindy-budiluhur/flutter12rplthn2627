import 'package:flutter/material.dart';

class AnimatedLikeButton extends StatefulWidget {
  const AnimatedLikeButton({super.key});

  @override
  State<AnimatedLikeButton> createState() => _AnimatedLikeButtonState();
}

class _AnimatedLikeButtonState extends State<AnimatedLikeButton> {
  bool isLiked = false;
  int likeCount = 128;
  double scale = 1.0;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      isLiked ? likeCount++ : likeCount--;
      scale = 1.35;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        scale = 1.0;
      });
    });
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
              isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isLiked ? const Color(0xFFFF4757) : Colors.grey[400],
              size: 26,
            ),
            onPressed: _toggleLike,
          ),
        ),
        Text(
          '$likeCount',
          style: TextStyle(
            color: Colors.grey[300],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
