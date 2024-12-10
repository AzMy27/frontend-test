class Dai {
  final String nik;
  final String nama;
  final String noHp;
  final String alamat;
  final String tempatLahir;
  final String tanggalLahir;
  final String pendidikanAkhir;
  final String statusKawin;
  final String? fotoDai;

  Dai({
    required this.nik,
    required this.nama,
    required this.noHp,
    required this.alamat,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.pendidikanAkhir,
    required this.statusKawin,
    this.fotoDai,
  });
  factory Dai.fromJson(Map<String, dynamic> json) {
    return Dai(
      nik: json['nik'] ?? '',
      nama: json['nama'] ?? '',
      noHp: json['no_hp'] ?? '',
      alamat: json['alamat'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      pendidikanAkhir: json['pendidikan_akhir'] ?? '',
      statusKawin: json['status_kawin'] ?? '',
      fotoDai: json['foto_dai'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nik': nik,
        'nama': nama,
        'no_hp': noHp,
        'alamat': alamat,
        'tanggal_lahir': tanggalLahir,
        'tempat_lahir': tempatLahir,
        'pendidikan_akhir': pendidikanAkhir,
        'status_kawin': statusKawin,
        'foto_dai': fotoDai,
      };
}
