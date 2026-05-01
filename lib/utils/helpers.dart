import 'package:flutter/material.dart';

class Helpers {
  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static Color getCategoryColor(String category) {
    switch (category) {
      case 'children': return Colors.green;
      case 'horror': return Colors.purple;
      case 'romance': return Colors.pink;
      case 'drama': return Colors.orange;
      case 'fantasy': return Colors.indigo;
      default: return Colors.blue;
    }
  }

  static String getCategoryShortName(String category) {
    switch (category) {
      case 'children': return 'Kids';
      case 'horror': return 'Horror';
      case 'romance': return 'Love';
      case 'drama': return 'Drama';
      case 'fantasy': return 'Fantasy';
      default: return 'Book';
    }
  }
}