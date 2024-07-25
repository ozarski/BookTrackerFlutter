class ImageLinks {
  String thumbnail;

  ImageLinks({required this.thumbnail});

  factory ImageLinks.fromJson(Map<String, dynamic> json) {
    return ImageLinks(
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
    };
  }
}