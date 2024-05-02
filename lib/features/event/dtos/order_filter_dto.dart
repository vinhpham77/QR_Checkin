class OrderFilterDto {
  String name;
  String value;
  bool isAsc;

  OrderFilterDto({
    required this.name,
    required this.value,
    required this.isAsc,
  });
}