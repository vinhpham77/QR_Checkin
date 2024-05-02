class SearchCriteria {
  String title;
  String keyword;
  int? categoryId;
  String sortField;
  bool isAsc;
  List<String> fields;

  SearchCriteria({
    required this.title,
    required this.keyword,
    required this.categoryId,
    required this.sortField,
    required this.isAsc,
    required this.fields,
  });
}