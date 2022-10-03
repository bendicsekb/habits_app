import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habits_app/list_design/add_entry_bottom_sheet.dart';
import 'package:habits_app/main.dart';
import 'package:habits_app/list_design/time_entry.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'entry_details.dart';

class HabitsApp extends StatelessWidget {
  const HabitsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entryListProvider);
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
    );
  }
}
