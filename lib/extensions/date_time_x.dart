extension DateTimeX on DateTime {
  String get toPodcastTimeStamp => '${year}_${month}_${day}_${hour}_$minute';
}
