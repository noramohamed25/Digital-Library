import 'package:digtalibrary/models/borrowed_book.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../data/book_data.dart';
import '../widgets/book_cards.dart';

class MyBooksScreen extends StatelessWidget {
  final User user;
  final Function(User) onUserUpdate;

  const MyBooksScreen({super.key, required this.user, required this.onUserUpdate});

  @override
  Widget build(BuildContext context) {
    final purchased = allBooks.where((b) => user.purchasedBooks.contains(b.id)).toList();
    
    final borrowed = user.borrowedBooks
        .map((borrowed) => BookWithBorrowInfo(
              book: allBooks.firstWhere((book) => book.id == borrowed.bookId),
              borrowedBook: borrowed,
            ))
        .where((info) => !info.borrowedBook.isExpired)
        .toList();
        
    final expired = user.borrowedBooks
        .map((borrowed) => BookWithBorrowInfo(
              book: allBooks.firstWhere((book) => book.id == borrowed.bookId),
              borrowedBook: borrowed,
            ))
        .where((info) => info.borrowedBook.isExpired)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildStatsHeader(purchased.length, borrowed.length),
          const TabBar(
            tabs: [
              Tab(text: '📚 Purchased'),
              Tab(text: '📖 Borrowed'),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildPurchasedTab(purchased, borrowed, expired),
                _buildBorrowedTab(borrowed, expired),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(int purchasedCount, int borrowedCount) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(Icons.shopping_bag, '$purchasedCount', 'Purchased'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStat(Icons.local_library, '$borrowedCount', 'Borrowed'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStat(Icons.star, '${user.xp}', 'Total XP'),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildPurchasedTab(List<Book> purchased, List<BookWithBorrowInfo> borrowed, List<BookWithBorrowInfo> expired) {
    if (purchased.isEmpty && borrowed.isEmpty && expired.isEmpty) {
      return const EmptyBooksWidget();
    }
    return ListView(
      children: [
        ...purchased.map((book) => PurchasedBookCard(book: book)),
      ],
    );
  }

  Widget _buildBorrowedTab(List<BookWithBorrowInfo> borrowed, List<BookWithBorrowInfo> expired) {
    if (borrowed.isEmpty && expired.isEmpty) {
      return const EmptyBooksWidget();
    }
    return ListView(
      children: [
        if (borrowed.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Currently Borrowed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ...borrowed.map((info) => BorrowedBookCard(
            book: info.book,
            borrowedBook: info.borrowedBook,
            onReturn: () {
              final updatedUser = user.copyWith(
                borrowedBooks: user.borrowedBooks.where((b) => b.bookId != info.book.id).toList(),
              );
              onUserUpdate(updatedUser);
            },
          )),
        ],
        if (expired.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Expired Borrows', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
          ),
          ...expired.map((info) => ExpiredBookCard(
            book: info.book,
            onRemove: () {
              final updatedUser = user.copyWith(
                borrowedBooks: user.borrowedBooks.where((b) => b.bookId != info.book.id).toList(),
              );
              onUserUpdate(updatedUser);
            },
          )),
        ],
      ],
    );
  }
}

class BookWithBorrowInfo {
  final Book book;
  final BorrowedBook borrowedBook;

  BookWithBorrowInfo({required this.book, required this.borrowedBook});
}

class EmptyBooksWidget extends StatelessWidget {
  const EmptyBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No books yet!\nGo to Library to borrow or buy books',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}