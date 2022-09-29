import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habits_app/string_extensions.dart';
import 'package:habits_app/time_entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'model.dart';

final entryListProvider = StateNotifierProvider<EntryList, List<Entry>>((ref) {
  var entryList = EntryList();
  entryList.addEntry("Entry 1", "test", DateTime(2022, 9, 27, 13, 12, 3),
      DateTime(2022, 2, 3, 14, 52, 47));
  entryList.addEntry("Entry 2", "test", DateTime(2022, 2, 3, 14, 53, 0),
      DateTime(2022, 2, 3, 17, 21, 35));
  entryList.addEntry("Entry 3", "test", DateTime(2022, 2, 3, 17, 22, 0),
      DateTime(2022, 2, 3, 18, 12, 0));
  // return entryList;
  return EntryList([
    Entry(
      id: "0",
      text: "Designing time entries",
      title: "reallylongtitle",
      startTime: DateTime(2022, 9, 27, 20, 12, 3),
    ),
    Entry(
      id: "1",
      text: "Make the app",
      title: "test",
      startTime: DateTime(2022, 2, 3, 13, 12, 3),
      endTime: DateTime(2022, 2, 3, 14, 52, 47),
      satisfaction: 3,
    ),
    Entry(
      id: "2",
      text: "Create Flutter project",
      title: "test",
      startTime: DateTime(2022, 2, 3, 14, 53, 0),
      endTime: DateTime(2022, 2, 3, 17, 21, 35),
      satisfaction: 5,
    ),
    Entry(
      id: "3",
      text: "Come up with ideas",
      title: "test",
      startTime: DateTime(2022, 2, 3, 17, 22, 0),
      endTime: DateTime(2022, 2, 3, 18, 12, 0),
      satisfaction: 4,
    ),
  ]);
});

final entryIdsProvider = StateProvider<List<String>>((ref) {
  final entryList = ref.watch(entryListProvider);
  return entryList.map((entry) => entry.id).toList();
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[300],
        canvasColor: Colors.grey[300],
        // bottomAppBarColor,
      ),
      home: const MyHomePage(title: 'Habits'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryIds = ref.watch(entryIdsProvider);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        shadowColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(title, style: const TextStyle(color: Colors.black)),
      ),
      body: ListView(
        children: [
          for (var entryId in entryIds) ...[
            const SizedBox(height: 6.0),
            TimeEntry(id: entryId),
          ]
        ],
      ),
      bottomSheet: AddEntryBottomSheet(),
    );
  }
}

class BottomSheetOpen extends StateNotifier<bool> {
  BottomSheetOpen() : super(false);

  void toggle() {
    state = !state;
  }
}

final bottomSheetOpen = StateNotifierProvider<BottomSheetOpen, bool>((ref) {
  return BottomSheetOpen();
});

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

    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext context) => AnimatedContainer(
        constraints: ref.watch(bottomSheetOpen)
            ? BoxConstraints(maxHeight: MediaQuery.of(context).size.height)
            : BoxConstraints(maxHeight: 50),
        decoration: bottomSheetBackgroundDecoration,
        curve: Curves.easeOutCubic,
        duration: Duration(milliseconds: 200),
        alignment: ref.watch(bottomSheetOpen)
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        child: Wrap(
          children: [
            FocusScope(
              child: Focus(
                onFocusChange: (hasFocus) {
                  ref.read(bottomSheetOpen.notifier).toggle();
                },
                child: Container(
                  decoration: bottomSheetFieldDecoration,
                  child: Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  newEntryTitle = splitted[0].toLowerCase();
                                  newEntryText = splitted[1].capitalize();
                                } else if (splitted.isNotEmpty &&
                                    splitted[0].isNotEmpty) {
                                  newEntryText = splitted[0].capitalize();
                                }
                                ref.read(entryListProvider.notifier).addEntry(
                                      newEntryText,
                                      newEntryTitle,
                                      DateTime.now(),
                                      null,
                                    );
                                newEntryController.clear();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                hintText: "What are you up to?",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

// A widget that animates height of a container with a textField from wrap content to screen height

class AddEntry extends ConsumerWidget {
  const AddEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryList = ref.watch(entryListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Add Entry", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Title',
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Text',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                entryList.addEntry(
                    "New",
                    "test",
                    DateTime(2022, 2, 3, 13, 12, 3),
                    DateTime(2022, 2, 3, 14, 52, 47));
                Navigator.pop(context);
              },
              child: const Text("Add Entry", style: TextStyle(fontSize: 24)))
        ],
      ),
    );
  }
}
