import 'package:flutter/material.dart';
import 'package:habits_app/list_design/habits_app.dart';
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

void main() {
  runApp(const ProviderScope(child: HabitsApp()));
}
