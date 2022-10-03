import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habits_app/main.dart';
import 'package:habits_app/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddEntryBottomSheet extends HookConsumerWidget {
  final bottomSheetBackgroundDecoration = BoxDecoration(
    color: Colors.grey[400],
    borderRadius: BorderRadius.circular(4.0),
  );
  final bottomSheetFieldDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4.0),
    border: Border.all(color: Colors.grey[600]!, width: 1.0),
  );

  AddEntryBottomSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newEntryController = useTextEditingController();
    final bottomSheetOpen = useState(false);
    final bottomSheetClosedHeight = 60.0;

    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext context) => AnimatedContainer(
        constraints: bottomSheetOpen.value
            ? BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 24)
            : BoxConstraints(maxHeight: bottomSheetClosedHeight),
        decoration: bottomSheetBackgroundDecoration,
        curve: Curves.easeOutCubic,
        duration: Duration(milliseconds: 200),
        alignment:
            bottomSheetOpen.value ? Alignment.topCenter : Alignment.center,
        child: Wrap(
          children: [
            FocusScope(
              child: Focus(
                onFocusChange: (hasFocus) {
                  bottomSheetOpen.value = hasFocus;
                },
                child: Container(
                  height: bottomSheetClosedHeight,
                  decoration: bottomSheetFieldDecoration,
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: newEntryController,
                            onChanged: (text) {
                              // print('First text field: $text');
                            },
                            onSubmitted: (String value) {
                              var newEntryTitle = 'no title';
                              var newEntryText = 'New entry';
                              final splitted = value.split(':');

                              if (splitted.length > 1) {
                                newEntryTitle =
                                    splitted[0].trim().toLowerCase();
                                newEntryText = splitted[1].trim().capitalize();
                              } else if (splitted.isNotEmpty &&
                                  splitted[0].isNotEmpty) {
                                newEntryText = splitted[0].trim().capitalize();
                              }
                              ref.read(entryListProvider.notifier).addEntry(
                                    newEntryText,
                                    newEntryTitle,
                                    DateTime.now(),
                                    null,
                                    null,
                                  );
                              newEntryController.clear();
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintText: "What are you up to?",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
