class QuranText {
  final int index;
  final int joz;
  final int pageNo;
  final int sura;
  final int aya;
  final String text;
  final String textClean;

  QuranText({
    required this.index,
    required this.joz,
    required this.pageNo,
    required this.sura,
    required this.aya,
    required this.text,
    required this.textClean,
  });

  factory QuranText.fromJson(Map<String, dynamic> json) {
    return QuranText(
      index: json['index'],
      joz: json['joz'],
      pageNo: json['pageNo'],
      sura: json['sura'],
      aya: json['aya'],
      text: json['text'],
      textClean: json['text_clean'],
    );
  }
}
