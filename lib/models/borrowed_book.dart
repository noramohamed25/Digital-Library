import 'package:flutter/material.dart';

class BorrowedBook {
  final String bookId;
  final DateTime borrowDate;
  final int days;

  BorrowedBook({
    required this.bookId,
    required this.borrowDate,
    required this.days,
  });

  int get remainingDays {
    final endDate = borrowDate.add(Duration(days: days));
    final remaining = endDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  bool get isExpired => remainingDays <= 0;
  
  Color get statusColor {
    if (isExpired) return Colors.red;
    if (remainingDays <= 3) return Colors.red.shade700;
    return Colors.orange.shade700;
  }
  
  Color get statusBgColor {
    if (isExpired) return Colors.red.shade100;
    if (remainingDays <= 3) return Colors.red.shade100;
    return Colors.orange.shade100;
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'borrowDate': borrowDate.toIso8601String(),
      'days': days,
    };
  }

  factory BorrowedBook.fromMap(Map<String, dynamic> map) {
    return BorrowedBook(
      bookId: map['bookId'],
      borrowDate: DateTime.parse(map['borrowDate']),
      days: map['days'],
    );
  }
}