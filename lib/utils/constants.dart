class AppConstants {
  static const String appName = 'Digital Library';
  static const String tagline = 'Your Online Bookstore & Library';
  
  // Borrow durations
  static const List<int> borrowDurations = [7, 14, 30];
  
  // XP rewards
  static const int initialXP = 50;
  static const int xpPerLevel = 100;
  
  // Category names
  static const List<String> categories = ['all', 'children', 'horror', 'romance', 'drama', 'fantasy'];
  
  static String getCategoryDisplayName(String category) {
    switch (category) {
      case 'children': return '🧸 Children';
      case 'horror': return '👻 Horror';
      case 'romance': return '💖 Romance';
      case 'drama': return '🎭 Drama';
      case 'fantasy': return '🐉 Fantasy';
      default: return 'All';
    }
  }
}