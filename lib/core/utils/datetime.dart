import 'package:intl/intl.dart';

class TimeFormate {
  static String formatTimeAgo(DateTime dateTime) {
    Duration timeAgo = DateTime.now().difference(dateTime);

    if (timeAgo.inSeconds < 60) {
      return 'just now';
    } else if (timeAgo.inMinutes < 60) {
      return '${timeAgo.inMinutes}m';
    } else if (timeAgo.inHours < 24) {
      return '${timeAgo.inHours}h';
    } else {
      return DateFormat('MMM dd').format(dateTime); // Format for older dates
    }
  }
}
