class Property {
  late int? id;
  late String title;
  late String description;
  late int size;
  late int floor;
  late String image;
  late int room;
  late int price;
  late String address;
  late String postcode;
  late String city;

  Property({
    this.id,
    required this.title,
    required this.description,
    required this.size,
    required this.floor,
    required this.image,
    required this.room,
    required this.price,
    required this.address,
    required this.postcode,
    required this.city,
  });

  Property.empty();

  factory Property.fromJson(json) {
    return Property(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      size: json['size'],
      floor: json['floor'],
      image: json['image'],
      room: json['room'],
      price: json['price'],
      address: json['address'],
      postcode: json['postcode'],
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "size": size,
      "floor": floor,
      "image": image,
      "room": room,
      "price": price,
      "address": address,
      "postcode": postcode,
      "city": city,
    };
  }
}
