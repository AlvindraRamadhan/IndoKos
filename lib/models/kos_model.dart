class Kos {
  final String id;
  final String name;
  final String location;
  final double price;
  final double rating;
  final int reviewers;
  final List<String> facilities;
  final String description;
  final List<String> images;
  bool isWishlisted;
  final String type; // 'bulanan' or 'tahunan'

  Kos({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.reviewers,
    required this.facilities,
    required this.description,
    required this.images,
    this.isWishlisted = false,
    this.type = 'bulanan',
  });
}
