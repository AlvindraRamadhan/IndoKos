import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(num amount,
    {String locale = 'id_ID', String symbol = 'Rp '}) {
  final format =
      NumberFormat.currency(locale: locale, symbol: symbol, decimalDigits: 0);
  return format.format(amount);
}

String formatDate(DateTime date) {
  return DateFormat('d MMMM yyyy', 'id_ID').format(date);
}

String timeAgoSinceDate(DateTime date, {bool numericDates = true}) {
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if (difference.inSeconds < 5) {
    return 'Baru saja';
  } else if (difference.inSeconds < 60) {
    return '${difference.inSeconds}d yang lalu';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m yang lalu';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h yang lalu';
  } else if (difference.inDays == 1) {
    return 'Kemarin';
  } else {
    return '${difference.inDays} hari yang lalu';
  }
}

Color getStatusBgColor(String status) {
  switch (status.toLowerCase()) {
    case 'dibatalkan':
      return Colors.red.shade100;
    case 'selesai':
      return Colors.grey.shade300;
    case 'dikonfirmasi':
      return Colors.green.shade100;
    case 'sedang berlangsung':
      return Colors.blue.shade100;
    default:
      return Colors.orange.shade100;
  }
}

Color getStatusTextColor(String status) {
  switch (status.toLowerCase()) {
    case 'dibatalkan':
      return Colors.red.shade800;
    case 'selesai':
      return Colors.grey.shade800;
    case 'dikonfirmasi':
      return Colors.green.shade800;
    case 'sedang berlangsung':
      return Colors.blue.shade800;
    default:
      return Colors.orange.shade800;
  }
}
