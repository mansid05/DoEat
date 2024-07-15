class BannerItem {
  final String id;
  final String image;

  BannerItem({
    required this.id,
    required this.image,
  });

  factory BannerItem.fromMap(Map<String, dynamic> data, String documentId) {
    return BannerItem(
      id: documentId,
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
    };
  }
}
