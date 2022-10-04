import 'package:flutter/material.dart';
import 'package:habits_app/block_activity_design/activity.dart';
import 'package:habits_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Block extends HookConsumerWidget {
  final String blockName;
  const Block({Key? key, required this.blockName}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityNamesPerBlockProvider);
    return Card(
      child: Column(
        children: [
          Text(blockName),
          GridView.builder(
            padding: const EdgeInsets.all(4),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.4,
            ),
            itemCount: activities[blockName]!.length + 1,
            itemBuilder: (context, index) {
              if (index == activities[blockName]!.length) {
                return const AddActivity();
              }
              return Activity(
                activityName: activities[blockName]![index],
              );
            },
          ),
        ],
      ),
    );
  }
}
