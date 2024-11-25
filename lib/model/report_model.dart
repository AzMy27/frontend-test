class Reports {
  final int id;
  final String title;
  final String place;
  final String date;
  final String description;
  final String validasiDesa;
  final String koreksiDesa;
  final String validasiKecamatan;
  final String koreksiKecamatan;
  final List<String> images;

  Reports({
    required this.id,
    required this.title,
    required this.place,
    required this.date,
    required this.description,
    required this.validasiDesa,
    required this.koreksiDesa,
    required this.validasiKecamatan,
    required this.koreksiKecamatan,
    required this.images,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      id: json['id'],
      title: json['title'],
      place: json['place'],
      date: json['date'],
      description: json['description'],
      validasiDesa: json['validasi_desa'],
      koreksiDesa: json['koreksi_desa'] ?? '',
      validasiKecamatan: json['validasi_kecamatan'],
      koreksiKecamatan: json['koreksi_kecamatan'] ?? '',
      images: (json['images'] as List<dynamic>?)?.map((image) => image.toString()).toList() ?? [],
    );
  }
}
