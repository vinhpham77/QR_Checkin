class ItemCounterDto<T> {
  final int counter;
  final List<T> items;

  ItemCounterDto(this.counter, this.items);

  factory ItemCounterDto.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return ItemCounterDto(
      json['counter'],
      (json['items'] as List).map((e) => fromJson(e)).toList(),
    );
  }
}