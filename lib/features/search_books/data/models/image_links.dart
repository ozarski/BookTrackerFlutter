class ImageLinks {
  String thumbnail;

  ImageLinks({required this.thumbnail});

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    var thumbnail = json['thumbnail'] as String? ?? '';
    if (thumbnail.isNotEmpty) {
      thumbnail = thumbnail
          .replaceAll('zoom=1', 'zoom=0')
          .replaceAll('zoom=5', 'zoom=0');
    }
    return ImageLinks(thumbnail: thumbnail);
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
    };
  }
}