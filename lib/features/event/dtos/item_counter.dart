class ItemCounterDTO<T> {
  final int counter;
  final List<T> items;

  ItemCounterDTO(this.counter, this.items);

  factory ItemCounterDTO.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return ItemCounterDTO(
      json['counter'],
      (json['items'] as List).map((e) => fromJson(e)).toList(),
    );
  }
}