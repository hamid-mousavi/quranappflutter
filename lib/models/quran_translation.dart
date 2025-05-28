class QuranTranslation {
  final int index;
  final int sura;
  final int aya;
  final String text;

  QuranTranslation({
    required this.index,
    required this.sura,
    required this.aya,
    required this.text,
  });

  factory QuranTranslation.fromJson(Map<String, dynamic> json) {
    return QuranTranslation(
      index: json['index'],
      sura: json['sura'],
      aya: json['aya'],
      text: json['text'],
    );
  }
}
