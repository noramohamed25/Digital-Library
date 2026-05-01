import 'package:flutter/material.dart';
import '../models/user.dart';
import 'library_screen.dart';
import 'my_books_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userAvatar;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userAvatar,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User currentUser;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    currentUser = User(
      name: widget.userName,
      email: widget.userEmail,
      avatarUrl: widget.userAvatar,
      xp: 50,
      purchasedBooks: [],
      borrowedBooks: [],
    );
  }

  void _updateUser(User updatedUser) {
    setState(() {
      currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${widget.userName.split(' ')[0]}! 👋'),
        actions: [
          _buildAvatar(),
          const SizedBox(width: 16),
          _buildXpBadge(),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          LibraryScreen(user: currentUser, onUserUpdate: _updateUser),
          MyBooksScreen(user: currentUser, onUserUpdate: _updateUser),
          ProfileScreen(user: currentUser),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ClipOval(
        child: Image.asset(
          currentUser.avatarUrl,
          width: 35,
          height: 35,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 35,
              height: 35,
              color: Colors.white24,
              child: const Icon(Icons.person, color: Colors.white),
            );
          },
        ),
      ),
    );
  }

  Widget _buildXpBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            '${currentUser.xp} XP • Lvl ${currentUser.level}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => setState(() => selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue.shade600,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.my_library_books), label: 'My Books'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}