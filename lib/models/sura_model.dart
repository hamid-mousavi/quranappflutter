class Sura {
  final int id;
  final String name;
  final int startPage;

  Sura({
    required this.id,
    required this.name,
    required this.startPage,
  });

  factory Sura.fromJson(Map<String, dynamic> json) {
    return Sura(
      id: json['id'] ?? 0,
      name: json['sura'] ?? json['sura_name'] ?? 'نامشخص',
      startPage: json['start_page'] ?? json['page'] ?? 0,
    );
  }
}
