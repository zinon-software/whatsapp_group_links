import 'package:flutter/material.dart';

import '../../../../core/utils/color_manager.dart';

class IconFloatingButton extends StatefulWidget {
  const IconFloatingButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.top,
    required this.right,
  });

  final VoidCallback onPressed;
  final double top;
  final double right;
  final Widget child;

  @override
  State<IconFloatingButton> createState() => _IconFloatingButtonState();
}

class _IconFloatingButtonState extends State<IconFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // الحركة تتكرر للأمام والخلف

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: widget.top + _animation.value,
          right: widget.right,
          child: IconButton(
            onPressed: widget.onPressed,
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsManager.fillColor,
                    backgroundBlendMode: BlendMode.overlay,
                    border: Border.all(
                      width: 1,
                      color: ColorsManager.primaryLight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                widget.child,
              ],
            ),
          ),
        );
      },
    );
  }
}
