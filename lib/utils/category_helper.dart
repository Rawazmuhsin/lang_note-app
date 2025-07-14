class CategoryHelper {
  static const Map<String, String> categoryEmojis = {
    'all': '📚',
    'greeting': '👋',
    'food & drink': '🍽️',
    'travel': '✈️',
    'courtesy': '🙏',
    'relationships': '❤️',
    'business': '💼',
    'academic': '📚',
    'general': '📝',
  };

  static String getEmoji(String category) {
    return categoryEmojis[category.toLowerCase()] ?? categoryEmojis['general']!;
  }

  static List<String> getAllCategories() {
    return [
      'All',
      'Greeting',
      'Food & Drink',
      'Travel',
      'Courtesy',
      'Relationships',
      'Business',
      'Academic',
      'General',
    ];
  }
}
