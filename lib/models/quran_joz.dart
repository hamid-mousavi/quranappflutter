class QuranJoz {
  final int id;
  final String joz;
  final int pageNoSt;

  QuranJoz({required this.id, required this.joz, required this.pageNoSt});

  factory QuranJoz.fromJson(Map<String, dynamic> json) {
    return QuranJoz(
      id: json['id'],
      joz: json['joz'],
      pageNoSt: json['pageNoSt'],
    );
  }
}
