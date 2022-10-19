import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// src: https://stackoverflow.com/questions/61919395/how-to-generate-random-string-in-dart
String getRandomString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

@immutable
class Entry {
  final String id;
  final String activityName;
  final String block;
  final DateTime startTime;
  final DateTime? endTime;

  const Entry({
    required this.id,
    required this.activityName,
    required this.block,
    required this.startTime,
    this.endTime,
  });

  Entry copyWith({
    String? id,
    String? activityName,
    String? block,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Entry(
      id: id ?? this.id,
      activityName: activityName ?? this.activityName,
      block: block ?? this.block,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

class EntryList extends StateNotifier<List<Entry>> {
  EntryList([List<Entry>? initialEntries]) : super(initialEntries ?? []);

  String addEntry(
      String text, String block, DateTime startTime, DateTime? endTime) {
    state = [
      ...state,
      Entry(
          id: getRandomString(24),
          activityName: text,
          block: block,
          startTime: startTime,
          endTime: endTime)
    ];
    return state.last.id;
  }

  void removeEntry(Entry target) {
    state = state.where((entry) => entry.id != target.id).toList();
  }

  Entry getEntry(String id) {
    return state.firstWhere((entry) => entry.id == id);
  }

  void stopClock(String? id) {
    state = state.map((entry) {
      if (entry.id == id) {
        return entry.copyWith(endTime: DateTime.now());
      } else {
        return entry;
      }
    }).toList();
  }

  void editEntry(String id, String? activityName, String? block,
      DateTime? startTime, DateTime? endTime) {
    state = state.map((entry) {
      if (entry.id == id) {
        return entry.copyWith(
          activityName: activityName,
          block: block,
          startTime: startTime,
          endTime: endTime,
        );
      } else {
        return entry;
      }
    }).toList();
  }
}
