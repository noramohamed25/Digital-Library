import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/borrowed_book.dart';
import '../utils/helpers.dart';

class PurchasedBookCard extends StatelessWidget {
  final Book book;

  const PurchasedBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final categoryColor = Helpers.getCategoryColor(book.category);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildBookImage(book, categoryColor, 50, 70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(book.category, categoryColor),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green.shade400),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        Helpers.getCategoryShortName(category),
        style: TextStyle(fontSize: 9, color: color),
      ),
    );
  }

  Widget _buildBookImage(Book book, Color color, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        book.imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: color.withOpacity(0.3),
            child: Icon(Icons.book, color: color),
          );
        },
      ),
    );
  }
}

class BorrowedBookCard extends StatelessWidget {
  final Book book;
  final BorrowedBook borrowedBook;
  final VoidCallback onReturn;

  const BorrowedBookCard({
    super.key,
    required this.book,
    required this.borrowedBook,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = Helpers.getCategoryColor(book.category);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          _buildBookImage(book, categoryColor, 50, 70),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  book.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                _buildRemainingDaysChip(),
              ],
            ),
          ),
          IconButton(
            onPressed: onReturn,
            icon: Icon(Icons.assignment_return, color: Colors.blue.shade400),
            tooltip: 'Return Book',
          ),
        ],
      ),
    );
  }

  Widget _buildBookImage(Book book, Color color, double width, double height) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        book.imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: color.withOpacity(0.3),
            child: Icon(Icons.book, color: color),
          );
        },
      ),
    );
  }

  Widget _buildRemainingDaysChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: borrowedBook.statusBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 12, color: borrowedBook.statusColor),
          const SizedBox(width: 4),
          Text(
            borrowedBook.isExpired 
                ? 'Expired' 
                : '${borrowedBook.remainingDays} days remaining',
            style: TextStyle(
              fontSize: 11,
              color: borrowedBook.statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ExpiredBookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onRemove;

  const ExpiredBookCard({
    super.key,
    required this.book,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              book.imageUrl,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 70,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.book, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(book.author, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Expired',
                    style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}