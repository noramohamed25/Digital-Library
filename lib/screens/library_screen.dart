import 'package:digtalibrary/widgets/book_grid.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../data/book_data.dart';
import '../widgets/category_chips.dart';   
     
import '../theme/app_theme.dart';

class LibraryScreen extends StatefulWidget {
  final User user;
  final Function(User) onUserUpdate;

  const LibraryScreen({super.key, required this.user, required this.onUserUpdate});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedDays = 7;
  String _selectedCategory = 'all';
  bool _showBorrowTab = true;

  @override
  Widget build(BuildContext context) {
    final freeBooks = getFreeBooks();
    final paidBooks = getPaidBooks();
    
    final filteredFreeBooks = _getFilteredBooks(freeBooks);
    final filteredPaidBooks = _getFilteredBooks(paidBooks);

    return Column(
      children: [
        _buildXpBanner(),
        CategoryChips(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) => setState(() => _selectedCategory = category),
        ),
        const SizedBox(height: 8),
        _buildBorrowBuyToggle(),
        const SizedBox(height: 16),
        Expanded(
          child: _showBorrowTab
              ? BookGrid(
                  books: filteredFreeBooks,
                  user: widget.user,
                  onUserUpdate: widget.onUserUpdate,
                  mode: 'borrow',
                  selectedDays: _selectedDays,
                  onDaysChanged: (days) => setState(() => _selectedDays = days),
                )
              : BookGrid(
                  books: filteredPaidBooks,
                  user: widget.user,
                  onUserUpdate: widget.onUserUpdate,
                  mode: 'buy',
                ),
        ),
      ],
    );
  }

  List<Book> _getFilteredBooks(List<Book> books) {
    if (_selectedCategory == 'all') return books;
    return books.where((book) => book.category == _selectedCategory).toList();
  }

  Widget _buildXpBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryBlue, AppTheme.darkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppTheme.amber, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📚 Read & Earn XP!',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Each book gives you 15-40 XP',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBorrowBuyToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showBorrowTab = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _showBorrowTab ? AppTheme.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '📖 Borrow (Free)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _showBorrowTab ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showBorrowTab = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !_showBorrowTab ? AppTheme.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '💰 Buy (Premium)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_showBorrowTab ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}