class QuranAyah {
  final int id;
  final int sura;
  final int aya;
  final String text;
  final int pageNo;
  final String translation;

  QuranAyah({
    required this.id,
    required this.sura,
    required this.aya,
    required this.text,
    required this.pageNo,
    required this.translation,
  });

  factory QuranAyah.fromMap(Map<String, dynamic> map) {
    return QuranAyah(
      id: map['id'],
      sura: map['sura'],
      aya: map['aya'],
      text: map['text'],
      pageNo: map['pageNo'],
      translation: map['translation'],
    );
  }
}
