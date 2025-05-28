class LatestPage {
  final int id;
  final String pageNo;

  LatestPage({required this.id, required this.pageNo});

  factory LatestPage.fromJson(Map<String, dynamic> json) {
    return LatestPage(
      id: json['id'],
      pageNo: json['pageNo'],
    );
  }
}
