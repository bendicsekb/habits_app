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
  final activityName;
  const Activity({Key? key, required this.activityName}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running = useState(false);
    return TextButton(
      onPressed: () {
        running.value = !running.value;
      },
      style: running.value ? _activityButtonStyle : _runningActivityButtonStyle,
      child: AnimatedCrossFade(
        crossFadeState: running.value
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 300),
        firstChild: Text(activityName),
        secondChild: SizedBox(
          width: 50,
          height: 50,
          child: Icon(Icons.play_arrow_rounded, size: 50),
        ),
      ),
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
