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
  final String text;
  final String title;
  final DateTime startTime;
  final DateTime? endTime;
  final int? satisfaction;

  const Entry({
    required this.id,
    required this.text,
    required this.title,
    required this.startTime,
    this.endTime,
    this.satisfaction,
  });

  Entry copyWith({
    String? id,
    String? text,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    int? satisfaction,
  }) {
    return Entry(
      id: id ?? this.id,
      text: text ?? this.text,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      satisfaction: satisfaction ?? this.satisfaction,
    );
  }
}

class EntryList extends StateNotifier<List<Entry>> {
  EntryList([List<Entry>? initialEntries]) : super(initialEntries ?? []);

  void addEntry(
      String text, String title, DateTime startTime, DateTime? endTime) {
    state = [
      ...state,
      Entry(
        id: getRandomString(24),
        text: text,
        title: title,
        startTime: startTime,
        endTime: endTime,
      )
    ];
  }

  void removeEntry(Entry target) {
    state = state.where((entry) => entry.id != target.id).toList();
  }

  Entry getEntry(String id) {
    return state.firstWhere((entry) => entry.id == id);
  }

  void stopClock(String id) {
    state = state.map((entry) {
      if (entry.id == id) {
        return entry.copyWith(endTime: DateTime.now());
      } else {
        return entry;
      }
    }).toList();
  }
}
