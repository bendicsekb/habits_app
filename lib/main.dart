import 'package:flutter/material.dart';
import 'package:habits_app/block_activity_design/habits_app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'block_activity_design/model/model.dart';

final entryListProvider = StateNotifierProvider<EntryList, List<Entry>>((ref) {
  return EntryList([
    Entry(
        id: '1',
        activityName: 'Wake up',
        block: 'Morning',
        startTime: DateTime(2021, 8, 21, 6, 0),
        endTime: DateTime(2021, 8, 21, 7, 0)),
    Entry(
        id: '2',
        activityName: 'Breakfast',
        block: 'Morning',
        startTime: DateTime(2021, 8, 21, 7, 0),
        endTime: DateTime(2021, 8, 21, 7, 15)),
    Entry(
        id: '3',
        activityName: 'Brush teeth',
        block: 'Morning',
        startTime: DateTime(2021, 8, 21, 7, 15),
        endTime: DateTime(2021, 8, 21, 7, 20)),
    Entry(
        id: '4',
        activityName: 'Shower',
        block: 'Morning',
        startTime: DateTime(2021, 8, 21, 7, 20),
        endTime: DateTime(2021, 8, 21, 7, 45)),
    Entry(
        id: '5',
        activityName: 'Dress',
        block: 'Morning',
        startTime: DateTime(2021, 8, 21, 7, 45),
        endTime: DateTime(2021, 8, 21, 7, 50)),
    Entry(
        id: '6',
        activityName: 'Pack lunch',
        block: 'Morning',
        startTime: DateTime(2021, 8, 21, 7, 50),
        endTime: DateTime(2021, 8, 21, 8, 0)),
    Entry(
        id: '7',
        activityName: 'Work',
        block: 'Job',
        startTime: DateTime(2021, 8, 21, 8, 0),
        endTime: DateTime(2021, 8, 21, 8, 15)),
    Entry(
        id: '8',
        activityName: 'Lunch',
        block: 'Job',
        startTime: DateTime(2021, 8, 21, 12, 0),
        endTime: DateTime(2021, 8, 21, 12, 15)),
    Entry(
        id: '9',
        activityName: 'Work',
        block: 'Job',
        startTime: DateTime(2021, 8, 21, 12, 15),
        endTime: DateTime(2021, 8, 21, 12, 30)),
    Entry(
        id: '10',
        activityName: 'Dinner',
        block: 'Afternoon',
        startTime: DateTime(2021, 8, 21, 18, 0),
        endTime: DateTime(2021, 8, 21, 18, 15)),
  ]);
});

final blockNamesProvider = Provider<List<String>>((ref) {
  final entryList = ref.watch(entryListProvider);
  return entryList.map((e) => e.block).toSet().toList();
});

final activityNamesPerBlockProvider =
    Provider<Map<String, List<String>>>((ref) {
  final entryList = ref.watch(entryListProvider);
  final blockNames = ref.watch(blockNamesProvider);
  final activityNamesPerBlock = <String, List<String>>{};
  for (final blockName in blockNames) {
    activityNamesPerBlock[blockName] = entryList
        .where((e) => e.block == blockName)
        .map((e) => e.activityName)
        .toSet()
        .toList();
  }
  return activityNamesPerBlock;
});

class BlockAddState extends StateNotifier<Map<String, bool>> {
  BlockAddState(Map<String, bool> state) : super(state);
  void add(String blockName) {
    state[blockName] = true;
    state = {...state};
  }

  void remove(String blockName) {
    state[blockName] = false;
    state = {...state};
  }
}

final blockAddProvider =
    StateNotifierProvider<BlockAddState, Map<String, bool>>((ref) {
  final blockNames = ref.read(blockNamesProvider);
  final blockNamesToBool = <String, bool>{};
  for (final blockName in blockNames) {
    blockNamesToBool[blockName] = false;
  }
  return BlockAddState(blockNamesToBool);
});

void main() {
  runApp(const ProviderScope(child: HabitsApp()));
}
