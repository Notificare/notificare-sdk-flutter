
//part 'notificare_time.g.dart';

//@JsonSerializable()
class NotificareTime {
  final int hours;
  final int minutes;

  NotificareTime(this.hours, this.minutes) {
    if (hours < 0 || hours > 23) {
      throw ArgumentError.value(hours, 'hours', 'Invalid time');
    }

    if (minutes < 0 || minutes > 59) {
      throw ArgumentError.value(minutes, 'minutes', 'Invalid time');
    }
  }

  factory NotificareTime.fromString(String time) {
    final parts = time.split(":");
    if (parts.length != 2) throw ArgumentError.value(time, 'time', 'Invalid time string');

    try {
      final hours = int.parse(parts[0]);
      final minutes = int.parse(parts[1]);

      return NotificareTime(hours, minutes);
    } on FormatException {
      throw ArgumentError.value(time, 'time', 'Invalid time string');
    }
  }

  factory NotificareTime.fromJson(String json) => NotificareTime.fromString(json);

  @override
  String toString() {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  String toJson() => toString();
}
