import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habits_app/main.dart';
import 'package:habits_app/model.dart';
import 'package:habits_app/list_design/time_entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EntryDetails extends HookConsumerWidget {
  Entry entry;
  EntryDetails({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryList = ref.watch(entryListProvider.notifier);
    final titleController = useTextEditingController(text: entry.title);
    final textController = useTextEditingController(text: entry.text);
    final titleUpdate = useValueListenable(titleController);
    final textUpdate = useValueListenable(textController);
    useEffect(() {
      titleController.text = titleUpdate.text;
      titleController.selection = TextSelection.fromPosition(
          TextPosition(offset: titleController.text.length));
      textController.text = textUpdate.text;
      textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length));
      entry = Entry(
          id: entry.id,
          title: titleController.text,
          text: textController.text,
          startTime: entry.startTime,
          endTime: entry.endTime,
          satisfaction: entry.satisfaction);
    }, [titleUpdate, textUpdate]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Edit Entry", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TimeEntry(entry: entry),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4.0),
            child: TextField(
              controller: titleController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(12,
                    maxLengthEnforcement:
                        MaxLengthEnforcement.truncateAfterCompositionEnds),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () => titleController.clear(),
                  icon: Icon(Icons.clear),
                ),
                labelText: 'Title',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4.0),
            child: TextField(
              controller: textController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(23,
                    maxLengthEnforcement:
                        MaxLengthEnforcement.truncateAfterCompositionEnds),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () => textController.clear(),
                    icon: Icon(
                      Icons.clear,
                    )),
                labelText: 'Text',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                entryList.editEntry(entry.id, textController.text.trim(),
                    titleController.text.trim(), null, null, null);

                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(fontSize: 24)))
        ],
      ),
    );
  }
}
