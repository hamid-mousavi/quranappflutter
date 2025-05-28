class QuranTranslation {
  final int sura;
  final int aya;
  final String text;

  QuranTranslation({
    required this.sura,
    required this.aya,
    required this.text,
  });

  factory QuranTranslation.fromMap(Map<String, dynamic> map) {
    return QuranTranslation(
      sura: map['sura'],
      aya: map['aya'],
      text: map['text'],
    );
  }
}
