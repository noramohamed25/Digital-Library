import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../data/book_data.dart';
import '../widgets/stat_cards.dart';
import '../utils/helpers.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final totalBooks = user.totalBooks;
    final categoryStats = _getCategoryStats();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 12),
          _buildUserInfo(),
          const SizedBox(height: 20),
          _buildXpCard(),
          const SizedBox(height: 20),
          _buildStatsRow(totalBooks),
          const SizedBox(height: 24),
          _buildFavoriteGenres(categoryStats),
          const SizedBox(height: 24),
          _buildAchievements(totalBooks),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 12,
            spreadRadius: 3,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          user.avatarUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.blue.shade200,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        Text(
          user.email,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildXpCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade400]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level ${user.level}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('${user.xp} / ${user.nextLevelXp} XP', style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: user.xpProgress,
            backgroundColor: Colors.white24,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 12),
          const Text('Keep reading to level up! 📚', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int totalBooks) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.shopping_bag,
            value: user.purchasedBooks.length.toString(),
            label: 'Books Owned',
            color: Colors.blue.shade400,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.local_library,
            value: user.borrowedBooks.length.toString(),
            label: 'Books Borrowed',
            color: Colors.green.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteGenres(Map<String, int> categoryStats) {
    if (categoryStats.isEmpty) return const SizedBox.shrink();
    
    return Column(
      children: [
        const Text('📚 Favorite Genres', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: categoryStats.entries.map((entry) {
            return _buildGenreChip(entry.key, entry.value);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGenreChip(String category, int count) {
    final color = Helpers.getCategoryColor(category);
    String icon;
    switch (category) {
      case 'children': icon = '🧸'; break;
      case 'horror': icon = '👻'; break;
      case 'romance': icon = '💖'; break;
      case 'drama': icon = '🎭'; break;
      case 'fantasy': icon = '🐉'; break;
      default: icon = '📚';
    }
    
    return Chip(
      avatar: Text(icon),
      label: Text('${Helpers.getCategoryShortName(category)} ($count)'),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildAchievements(int totalBooks) {
    return Column(
      children: [
        const Text('🏆 Achievements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: [
            _buildBadge('Reader', user.xp > 50),
            _buildBadge('Collector', user.purchasedBooks.length > 1),
            _buildBadge('Explorer', user.borrowedBooks.isNotEmpty),
            _buildBadge('Bookworm', totalBooks > 3),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String name, bool isUnlocked) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isUnlocked ? Colors.amber.withOpacity(0.2) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isUnlocked ? Colors.amber : Colors.grey.shade400),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isUnlocked ? Icons.emoji_events : Icons.lock_outline, size: 14, color: isUnlocked ? Colors.amber : Colors.grey),
          const SizedBox(width: 4),
          Text(name, style: TextStyle(fontSize: 12, color: isUnlocked ? Colors.black87 : Colors.grey)),
        ],
      ),
    );
  }

  Map<String, int> _getCategoryStats() {
    final Map<String, int> stats = {};
    for (var book in allBooks) {
      if (user.purchasedBooks.contains(book.id) || user.borrowedBooks.any((b) => b.bookId == book.id)) {
        stats[book.category] = (stats[book.category] ?? 0) + 1;
      }
    }
    return stats;
  }
}