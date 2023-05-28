import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smalllike;

  const LikeAnimation(
      {super.key,
      required this.child,
      this.duration = const Duration(milliseconds: 150),
      required this.isAnimating,
      this.onEnd,
      this.smalllike = false}
    );

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1,end: 1.2).animate(controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    if(widget.isAnimating != oldWidget.isAnimating){
      startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  startAnimation() async{
    if(widget.isAnimating || widget.smalllike){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(Duration(milliseconds: 200,));

      if(widget.onEnd != null){
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
