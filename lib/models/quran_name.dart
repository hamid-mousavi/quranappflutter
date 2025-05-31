class QuranName {
  final int id;
  final String sura;
  final int page;
  final String? revelationType; // فیلد جدید

  QuranName({
    required this.id,
    required this.sura,
    required this.page,
    this.revelationType,
  });

  factory QuranName.fromJson(Map<String, dynamic> json) {
    return QuranName(
      id: json['id'] ?? 0,
      sura: json['sura'] ?? 'نامشخص',
      page: json['page'] ?? 0,
      revelationType: json['revelationType'],
    );
  }
}
