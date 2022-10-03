import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habits_app/list_design/entry_details.dart';
import 'package:habits_app/model.dart';
import 'package:intl/intl.dart';

import '../main.dart';

String formatDuration(Duration duration) {
  String hours = duration.inHours.toString().padLeft(0, '2');
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
  // return "$hours:$minutes";
}

String formatHour(Duration duration) {
  String hours = duration.inHours.toString().padLeft(0, '2');
  return hours;
}

String formatMinute(Duration duration) {
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  return minutes;
}

String formatSecond(Duration duration) {
  String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return seconds;
}

class TimeEntry extends ConsumerWidget {
  final Entry entry;

  const TimeEntry({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final dayDateFormat = DateFormat("EEE, d MMM ''yy");
    final hourFormat = DateFormat("HH:mm");
    final hourStyle = TextStyle(
      fontSize: 10,
      color: Colors.grey[600],
    );
    final entryTextStyle = TextStyle(
      fontSize: 18,
      color: Colors.grey[800],
    );
    const titleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return Slidable(
      key: ValueKey<String>(entry.id),
      enabled: entry.endTime == null,
      endActionPane: ActionPane(
        extentRatio: 0.20,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(4.0),
            flex: 1,
            onPressed: (BuildContext context) {
              ref.read(entryListProvider.notifier).stopClock(entry.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.stop,
            label: 'Stop',
          ),
          Container(
            width: 4.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 12.0, left: 12.0, right: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.title, style: titleStyle),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(hourFormat.format(entry.startTime),
                              style: hourStyle),
                          if (entry.endTime != null)
                            Text(" - ${hourFormat.format(entry.endTime!)}",
                                style: hourStyle),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.text, style: entryTextStyle),
                      Row(
                        children: [EntryDuration(entry: entry)],
                      )
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...[
                              for (var i = 0;
                                  i < (entry.satisfaction ?? 0);
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: Container(
                                    height: 5.0,
                                    width: 5.0,
                                    decoration: BoxDecoration(
                                      color: SatisfactionColor.values[i].color,
                                    ),
                                  ),
                                )
                            ].reversed
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EntryDuration extends StatelessWidget {
  final Entry entry;

  EntryDuration({Key? key, required this.entry}) : super(key: key);

  final activeDurationHoursStyle = TextStyle(
    fontSize: 22,
    color: Colors.green[600],
    fontWeight: FontWeight.bold,
  );
  final activeDurationMinutesStyle = TextStyle(
    fontSize: 14,
    color: Colors.green[600],
  );
  final activeDurationSecondsStyle = TextStyle(
    fontSize: 10,
    color: Colors.green[600],
  );
  final inactiveDurationHoursStyle = TextStyle(
    fontSize: 22,
    color: Colors.grey[600],
  );
  final inactiveDurationMinutesStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
  );
  final inactiveDurationSecondsStyle = TextStyle(
    fontSize: 10,
    color: Colors.grey[600],
  );

  @override
  Widget build(BuildContext context) {
    if (entry.endTime != null) {
      final duration = entry.endTime!.difference(entry.startTime);
      return Row(
        children: [
          Text(formatHour(duration), style: inactiveDurationHoursStyle),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(formatMinute(duration), style: inactiveDurationMinutesStyle),
              Text(formatSecond(duration), style: inactiveDurationSecondsStyle),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Row(
                children: [
                  Text(formatHour(DateTime.now().difference(entry.startTime)),
                      style: activeDurationHoursStyle),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          formatMinute(
                              DateTime.now().difference(entry.startTime)),
                          style: activeDurationMinutesStyle),
                      Text(
                          formatSecond(
                              DateTime.now().difference(entry.startTime)),
                          style: activeDurationSecondsStyle),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      );
    }
  }
}

enum SatisfactionColor { lowest, low, medium, high, highest }

extension AcceptedItemStatusExtension on SatisfactionColor {
  Color get color {
    switch (this) {
      case SatisfactionColor.lowest:
        return Colors.red[300]!;
      case SatisfactionColor.low:
        return Colors.orange[300]!;
      case SatisfactionColor.medium:
        return Colors.yellow;
      case SatisfactionColor.high:
        return Colors.green[300]!;
      case SatisfactionColor.highest:
        return Colors.green[700]!;
    }
  }
}
