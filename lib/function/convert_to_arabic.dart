String convertToArabicNumber(int number) {
  final arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return number.toString().split('').map((e) {
    final digit = int.tryParse(e);
    return digit != null ? arabicNumbers[digit] : e;
  }).join();
}
