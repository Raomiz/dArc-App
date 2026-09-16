import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/o_theme.dart';

/// Commit is a gold threshold — rest `#c9a227`, press soft `#e6d08a`.
///
/// Downscale ~0.97 over 80–120ms + light haptic. Burst still crosses.
class CommitButton extends StatefulWidget {
  const CommitButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  State<CommitButton> createState() => _CommitButtonState();
}

class _CommitButtonState extends State<CommitButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _burst;
  bool _crossing = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _burst = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed == value || widget.onPressed == null) return;
    setState(() => _pressed = value);
    if (value) {
      // Fire-and-forget: awaiting the platform channel hangs widget tests.
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _cross() async {
    if (widget.onPressed == null || _crossing) return;
    setState(() => _crossing = true);
    if (!mounted) return;
    await _burst.forward(from: 0);
    if (!mounted) return;
    widget.onPressed!();
    if (mounted) {
      setState(() {
        _crossing = false;
        _pressed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fill = _pressed ? OColors.commitSoft : OColors.commit;
    return AnimatedBuilder(
      animation: _burst,
      builder: (context, child) {
        final t = Curves.easeOutCubic.transform(_burst.value);
        return CustomPaint(
          foregroundPainter: _BurstPainter(progress: t),
          child: child,
        );
      },
      child: AnimatedScale(
        scale: _pressed ? OType.commitPressScale : 1,
        duration: OType.commitPress,
        curve: Curves.easeOut,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: OColors.commitSoft.withValues(alpha: _pressed ? 0.55 : 0.42),
                blurRadius: _pressed ? 16 : 22,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: OColors.commit.withValues(alpha: 0.28),
                blurRadius: 8,
                spreadRadius: -1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: fill,
            borderRadius: BorderRadius.circular(18),
            child: Listener(
              onPointerDown: (_) => _setPressed(true),
              onPointerUp: (_) => _setPressed(false),
              onPointerCancel: (_) => _setPressed(false),
              child: InkWell(
                onTap: widget.onPressed == null ? null : _cross,
                borderRadius: BorderRadius.circular(18),
                splashColor: OColors.commitSoft.withValues(alpha: 0.45),
                highlightColor: OColors.commitSoft.withValues(alpha: 0.2),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 58,
                    minWidth: double.infinity,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Center(
                      child: Text(
                        widget.label,
                        textAlign: TextAlign.center,
                        style: OType.commit,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.longestSide * 0.72;
    final radius = 8 + maxR * progress;
    final fade = (1 - progress).clamp(0.0, 1.0);
    final ring = Paint()
      ..color = OColors.commitSoft.withValues(alpha: 0.55 * fade)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * fade;
    canvas.drawCircle(center, radius, ring);
    canvas.drawCircle(
      center,
      radius * 0.72,
      Paint()
        ..color = OColors.commit.withValues(alpha: 0.22 * fade)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10 * fade,
    );
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
