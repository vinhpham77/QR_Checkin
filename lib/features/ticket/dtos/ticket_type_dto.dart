class TicketTypeDto {
  int id;
  String name;
  int eventId;
  String description;
  double? price;
  int? quantity;

  TicketTypeDto({
    required this.id,
    required this.name,
    required this.eventId,
    required this.description,
    required this.price,
    required this.quantity,
  });

  factory TicketTypeDto.fromJson(Map<String, dynamic> json) {
    return TicketTypeDto(
      id: json['id'],
      name: json['name'],
      eventId: json['eventId'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'eventId': eventId,
      'description': description,
      'price': price,
      'quantity': quantity,
    };
  }

  TicketTypeDto copyWith({
    int? id,
    String? name,
    int? eventId,
    String? description,
    double? price,
    int? quantity,
  }) {
    return TicketTypeDto(
      id: id ?? this.id,
      name: name ?? this.name,
      eventId: eventId ?? this.eventId,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}