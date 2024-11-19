class Reports {
  final String title;
  final String place;
  final String date;
  final String description;
  final String images;

  Reports({
    required this.title,
    required this.place,
    required this.date,
    required this.description,
    required this.images,
  });
  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      title: json['title'] ?? '',
      place: json['place'] ?? '',
      date: json['no_hp'] ?? '',
      description: json['tempat_lahir'] ?? '',
      images: json['tanggal_lahir'] ?? '',
    );
  }
}
