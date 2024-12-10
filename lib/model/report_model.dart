class Reports {
  final int? id;
  final String title;
  final String type;
  final String place;
  final String date;
  final String description;
  final String? coordinatePoint;
  final String target;
  final String purpose;
  final String validasiDesa;
  final String koreksiDesa;
  final String validasiKecamatan;
  final String koreksiKecamatan;
  final List<String> images;

  Reports({
    required this.id,
    required this.title,
    required this.type,
    required this.place,
    required this.date,
    required this.description,
    required this.coordinatePoint,
    required this.target,
    required this.purpose,
    required this.validasiDesa,
    required this.koreksiDesa,
    required this.validasiKecamatan,
    required this.koreksiKecamatan,
    required this.images,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0'),
      title: json['title'],
      type: json['type'],
      place: json['place'],
      date: json['date'],
      target: json['target'],
      purpose: json['purpose'],
      description: json['description'],
      coordinatePoint: json['coordinate_point'] ?? '',
      validasiDesa: json['validasi_desa'] ?? '',
      koreksiDesa: json['koreksi_desa'] ?? '',
      validasiKecamatan: json['validasi_kecamatan'] ?? '',
      koreksiKecamatan: json['koreksi_kecamatan'] ?? '',
      images: (json['images'] as List<dynamic>?)?.map((image) => image.toString()).toList() ?? [],
    );
  }
}
