import 'package:flutter/material.dart';
import 'package:habits_app/block_activity_design/block.dart';
import 'package:habits_app/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HabitsApp extends StatelessWidget {
  const HabitsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habits app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Habits'),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockNames = ref.watch(blockNamesProvider);

    // kirakni egy widgetbe (egy input csak blockName-el) ami megmondja hogy mit kell mutatni (hookConsumerWidgetnek csinalni)
    final isAddActivities = ref.watch(blockAddProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: blockNames.length,
        itemBuilder: (BuildContext context, int index) {
          return Block(
            blockName: blockNames[index],
            isAddActivity: isAddActivities[blockNames[index]]!,
          );
        },
      ),
    );
  }
}
