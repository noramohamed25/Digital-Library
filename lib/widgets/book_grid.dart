// lib/widgets/book_grid.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../models/borrowed_book.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class BookGrid extends StatelessWidget {
  final List<Book> books;
  final User user;
  final Function(User) onUserUpdate;
  final String mode;
  final int? selectedDays;
  final Function(int)? onDaysChanged;

  const BookGrid({
    super.key,
    required this.books,
    required this.user,
    required this.onUserUpdate,
    required this.mode,
    this.selectedDays,
    this.onDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_library, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No books in this category yet! 📚',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return _BookCard(
          book: book,
          user: user,
          onUserUpdate: onUserUpdate,
          mode: mode,
          selectedDays: selectedDays,
          onDaysChanged: onDaysChanged,
        );
      },
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final User user;
  final Function(User) onUserUpdate;
  final String mode;
  final int? selectedDays;
  final Function(int)? onDaysChanged;

  const _BookCard({
    required this.book,
    required this.user,
    required this.onUserUpdate,
    required this.mode,
    this.selectedDays,
    this.onDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isOwned = user.purchasedBooks.contains(book.id);
    final isBorrowed = user.borrowedBooks.any((b) => b.bookId == book.id);
    final isAvailable = mode == 'borrow' ? !isBorrowed : !isOwned;
    final categoryColor = Helpers.getCategoryColor(book.category);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookCover(book, categoryColor),
          _buildBookInfo(
            book, 
            categoryColor, 
            isOwned, 
            isBorrowed, 
            isAvailable, 
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildBookCover(Book book, Color color) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.asset(
            book.imageUrl,
            height: 130,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 130,
                color: color.withOpacity(0.3),
                child: Icon(Icons.book, size: 50, color: color),
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              Helpers.getCategoryShortName(book.category),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookInfo(
    Book book,
    Color color,
    bool isOwned,
    bool isBorrowed,
    bool isAvailable,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (mode == 'borrow')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isBorrowed ? 'Borrowed' : 'Free',
                    style: TextStyle(
                      fontSize: 10,
                      color: isBorrowed ? Colors.blue.shade700 : Colors.blue.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Text(
                  '\$${book.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2196F3)),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: isAvailable 
                    ? () => mode == 'borrow' 
                        ? _handleBorrow(context, book) 
                        : _handleBuy(context, book)
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAvailable ? Colors.blue.shade400 : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(0, 28),
                  ),
                  child: Text(
                    mode == 'borrow'
                        ? (isBorrowed ? 'Borrowed' : 'Borrow')
                        : (isOwned ? 'Owned' : 'Buy'),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBorrow(BuildContext context, Book book) {
    final alreadyBorrowed = user.borrowedBooks.any((b) => b.bookId == book.id);
    
    if (alreadyBorrowed) {
      Helpers.showSnackBar(context, 'You already borrowed "${book.title}"! 📖');
      return;
    }

    final days = selectedDays ?? 7;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          var tempDays = days;
          return AlertDialog(
            title: Text('Borrow "${book.title}"'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select duration:'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: AppConstants.borrowDurations.map((d) {
                    return _buildDurationButton(d, tempDays, (value) {
                      setDialogState(() => tempDays = value);
                    });
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'You will get +${book.xpReward} XP',
                  style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedUser = user.copyWith(
                    borrowedBooks: [
                      ...user.borrowedBooks,
                      BorrowedBook(
                        bookId: book.id,
                        borrowDate: DateTime.now(),
                        days: tempDays,
                      ),
                    ],
                  );
                  updatedUser.addXp(book.xpReward);
                  onUserUpdate(updatedUser);
                  
                  if (onDaysChanged != null && tempDays != selectedDays) {
                    onDaysChanged!(tempDays);
                  }
                  
                  Navigator.pop(context);
                  Helpers.showSnackBar(
                    context, 
                    '✅ Borrowed "${book.title}" for $tempDays days! +${book.xpReward} XP',
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade400),
                child: const Text('Borrow'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDurationButton(int days, int selectedDays, Function(int) onSelect) {
    final isSelected = selectedDays == days;
    return GestureDetector(
      onTap: () => onSelect(days),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade400 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$days days',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _handleBuy(BuildContext context, Book book) {
    final isOwned = user.purchasedBooks.contains(book.id);
    
    if (isOwned) {
      Helpers.showSnackBar(context, 'You already own "${book.title}"! 💪');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buy "${book.title}"'),
        content: Text('Price: \$${book.price}\n\n+${book.xpReward} XP reward!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedUser = user.copyWith(
                purchasedBooks: [...user.purchasedBooks, book.id],
              );
              updatedUser.addXp(book.xpReward);
              onUserUpdate(updatedUser);
              
              Navigator.pop(context);
              Helpers.showSnackBar(
                context, 
                '🎉 Purchased "${book.title}"! +${book.xpReward} XP',
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade400),
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}