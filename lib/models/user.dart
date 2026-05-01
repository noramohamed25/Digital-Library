import 'borrowed_book.dart';

class User {
  final String name;
  final String email;
  final String avatarUrl;
  int xp;
  int level;
  List<String> purchasedBooks;
  List<BorrowedBook> borrowedBooks;

  User({
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.xp = 0,
    this.level = 1,
    this.purchasedBooks = const [],
    this.borrowedBooks = const [],
  });

  int get nextLevelXp => level * 100;
  double get xpProgress => xp / nextLevelXp;
  int get totalBooks => purchasedBooks.length + borrowedBooks.length;

  void addXp(int amount) {
    xp += amount;
    while (xp >= nextLevelXp) {
      xp -= nextLevelXp;
      level++;
    }
  }

  User copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    int? xp,
    int? level,
    List<String>? purchasedBooks,
    List<BorrowedBook>? borrowedBooks,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      purchasedBooks: purchasedBooks ?? this.purchasedBooks,
      borrowedBooks: borrowedBooks ?? this.borrowedBooks,
    );
  }
}