class QuranName {
  final int id;
  final String sura;
  final int page;

  QuranName({required this.id, required this.sura, required this.page});

  factory QuranName.fromJson(Map<String, dynamic> json) {
    return QuranName(
      id: json['id'] ?? 0,
      sura: json['sura'] ?? 'نامشخص',
      page: json['page'] ?? 0,
    );
  }
}
