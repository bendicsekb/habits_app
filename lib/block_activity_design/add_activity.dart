import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habits_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _addActivityButtonStyle = TextButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.grey,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

class AddActivityButton extends HookConsumerWidget {
  final String currentBlock;
  const AddActivityButton({Key? key, required this.currentBlock})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        ref.read(blockAddProvider.notifier).add(currentBlock);
      },
      style: _addActivityButtonStyle,
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }
}

class AddActivityCard extends HookConsumerWidget {
  final String currentBlock;
  const AddActivityCard({Key? key, required this.currentBlock})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    return Card(
      child: Column(
        children: [
          const Text("Add activity"),
          TextField(
            controller: controller,
          ),
          TextButton(
            onPressed: () {
              ref.read(entryListProvider.notifier).addEntry(
                  controller.text, currentBlock, DateTime.now(), null);
              ref.read(blockAddProvider.notifier).remove(currentBlock);
            },
            style: _addActivityButtonStyle,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
