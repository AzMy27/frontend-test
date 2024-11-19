class Dai {
  final String nik;
  final String nama;
  final String noHp;
  final String tempatLahir;
  final String tanggalLahir;
  final String alamat;
  final String pendidikanAkhir;
  final String statusKawin;

  Dai({
    required this.nik,
    required this.nama,
    required this.noHp,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.alamat,
    required this.pendidikanAkhir,
    required this.statusKawin,
  });
  factory Dai.fromJson(Map<String, dynamic> json) {
    return Dai(
      nik: json['nik'] ?? '',
      nama: json['nama'] ?? '',
      noHp: json['no_hp'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      alamat: json['alamat'] ?? '',
      pendidikanAkhir: json['pendidikan_akhir'] ?? '',
      statusKawin: json['status_kawin'] ?? '',
    );
  }
}
