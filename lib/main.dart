import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habits_app/entry_details.dart';
import 'package:habits_app/string_extensions.dart';
import 'package:habits_app/time_entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'model.dart';

final entryListProvider = StateNotifierProvider<EntryList, List<Entry>>((ref) {
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
    final entries = ref.watch(entryListProvider);
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
      body: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Scrollbar(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(height: 6.0),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EntryDetails(entry: entries[index])),
                        );
                      },
                      child: TimeEntry(entry: entries[index])),
                  index == entries.length - 1
                      ? const SizedBox(height: 6.0)
                      : const SizedBox(height: 0.0),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: AddEntryBottomSheet(),
      // // Test button
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Add Entry',
      //   child: const Icon(Icons.add),
      // ),
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
    final bottomSheetClosedHeight = 60.0;

    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext context) => AnimatedContainer(
        constraints: ref.watch(bottomSheetOpen)
            ? BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 24)
            : BoxConstraints(maxHeight: bottomSheetClosedHeight),
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
