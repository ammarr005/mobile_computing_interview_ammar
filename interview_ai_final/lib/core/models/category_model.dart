class Category {
  final int id;
  final String title;
  final String subtitle;
  final String iconKey;

  Category({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconKey,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      iconKey: json['icon_key'],
    );
  }
}
