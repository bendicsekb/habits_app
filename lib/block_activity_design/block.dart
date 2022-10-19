import 'package:flutter/material.dart';
import 'package:habits_app/block_activity_design/activity.dart';
import 'package:habits_app/block_activity_design/add_activity.dart';
import 'package:habits_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Block extends HookConsumerWidget {
  final bool isAddActivity;
  final String blockName;
  const Block({Key? key, required this.blockName, required this.isAddActivity})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityNamesPerBlockProvider);

    return isAddActivity
        ? AddActivityCard(currentBlock: blockName)
        : Card(
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
                      return AddActivityButton(currentBlock: blockName);
                    }
                    return Activity(
                      activityName: activities[blockName]![index],
                      blockName: blockName,
                    );
                  },
                ),
              ],
            ),
          );
  }
}
