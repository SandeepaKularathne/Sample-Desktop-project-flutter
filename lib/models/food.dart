class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String category;
  final int bowlsAvailable;
  final bool isHot; // Indicates if item should show hot indicator

  const Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.bowlsAvailable,
    this.isHot = false,
  });
}