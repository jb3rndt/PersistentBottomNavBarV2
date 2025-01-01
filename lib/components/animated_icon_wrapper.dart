import "package:flutter/material.dart";

class AnimatedIconWrapper extends StatefulWidget {
  AnimatedIconWrapper({
    required this.icon,
    Key? key,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.linear,
    this.color,
    this.size,
    this.semanticLabel,
    this.textDirection,
  }) : super(key: key ?? GlobalKey<AnimatedIconWrapperState>());

  final Duration duration;
  final Curve curve;

  final AnimatedIconData icon;
  final Color? color;
  final double? size;
  final String? semanticLabel;
  final TextDirection? textDirection;

  @override
  State<AnimatedIconWrapper> createState() => AnimatedIconWrapperState();
}

class AnimatedIconWrapperState extends State<AnimatedIconWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.toDouble(), end: 1.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  void forward() {
    _controller.forward();
  }

  void reverse() {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  AnimationController get controller => _controller;

  @override
  Widget build(BuildContext context) => AnimatedIcon(
        icon: widget.icon,
        color: widget.color,
        size: widget.size,
        semanticLabel: widget.semanticLabel,
        textDirection: widget.textDirection,
        progress: _animation,
      );
}
