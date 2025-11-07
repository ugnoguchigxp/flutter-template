import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  const GameControls({
    required this.onMoveLeft,
    required this.onMoveRight,
    required this.onMoveDown,
    required this.onRotateClockwise,
    required this.onRotateCounterClockwise,
    super.key,
  });

  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;
  final VoidCallback onMoveDown;
  final VoidCallback onRotateClockwise;
  final VoidCallback onRotateCounterClockwise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ControlButton(
            icon: Icons.arrow_back,
            onPressed: onMoveLeft,
            tooltip: '左移動',
          ),
          _ControlButton(
            icon: Icons.arrow_forward,
            onPressed: onMoveRight,
            tooltip: '右移動',
          ),
          _ControlButton(
            icon: Icons.arrow_downward,
            onPressed: onMoveDown,
            tooltip: 'ハードドロップ',
          ),
          _ControlButton(
            icon: Icons.rotate_left,
            onPressed: onRotateCounterClockwise,
            tooltip: '左回転',
          ),
          _ControlButton(
            icon: Icons.rotate_right,
            onPressed: onRotateClockwise,
            tooltip: '右回転',
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Semantics(
          label: tooltip,
          button: true,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
