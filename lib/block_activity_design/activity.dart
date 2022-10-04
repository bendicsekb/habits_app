import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _activityButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.blue,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

final _runningActivityButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.green,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

class Activity extends HookConsumerWidget {
  final String activityName;
  const Activity({Key? key, required this.activityName}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running = useState(false);
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1000),
    );
    return TextButton(
      onPressed: () {
        running.value = !running.value;
        if (running.value) {
          controller.forward();
        } else {
          controller.reverse();
        }
      },
      style: running.value ? _runningActivityButtonStyle : _activityButtonStyle,
      child: Center(
        child: AnimatedPlayPauseButton(
          controller: controller,
          activityName: activityName,
          running: running.value,
        ),
      ),
    );
  }
}

class AnimatedPlayPauseButton extends HookConsumerWidget {
  final String activityName;
  final bool running;
  final AnimationController controller;
  final TweenSequence<double> _opacitySequence;
  AnimatedPlayPauseButton({
    Key? key,
    required this.controller,
    required this.activityName,
    required this.running,
  })  : _opacitySequence = TweenSequence<double>([
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ),
            weight: 1.0,
          ),
          TweenSequenceItem<double>(
            tween: ConstantTween<double>(1.0),
            weight: 1.0,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: 1.0,
              end: 0.0,
            ),
            weight: 1.0,
          ),
        ]),
        super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opacitySequence = useAnimation(_opacitySequence.animate(controller));
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: [
            Opacity(
              opacity: 1 - opacitySequence,
              child: Text(activityName),
            ),
            running
                ? Opacity(
                    opacity: opacitySequence,
                    child: const Icon(Icons.play_arrow_rounded, size: 50),
                  )
                : Opacity(
                    opacity: opacitySequence,
                    child: const Icon(Icons.pause_rounded, size: 50),
                  ),
          ],
        );
      },
    );
  }
}

class AddActivity extends HookConsumerWidget {
  const AddActivity({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {},
      style: _activityButtonStyle,
      child: Icon(Icons.add),
    );
  }
}
