class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double price;
  final bool isFree;
  final int xpReward;
  final String category;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.price,
    required this.isFree,
    required this.category,
    this.xpReward = 10,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? imageUrl,
    double? price,
    bool? isFree,
    int? xpReward,
    String? category,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      category: category ?? this.category,
      xpReward: xpReward ?? this.xpReward,
    );
  }
}