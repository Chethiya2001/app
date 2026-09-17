class Hotel {
  const Hotel({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.postcode,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.images,
  });
  final int id;
  final String title;
  final String description;
  final String address;
  final String postcode;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final HotelImages images;

  factory Hotel.fromJson(Map<String, dynamic> json) {
    final imageData = json['image'];
    if (imageData is! Map<String, dynamic>) {
      throw const FormatException('Hotel image data is invalid.');
    }
    return Hotel(
      id: _int(json, 'id'),
      title: _string(json, 'title'),
      description: _string(json, 'description'),
      address: _string(json, 'address'),
      postcode: _string(json, 'postcode'),
      phoneNumber: _string(json, 'phoneNumber'),
      latitude: _double(json, 'latitude'),
      longitude: _double(json, 'longitude'),
      images: HotelImages.fromJson(imageData),
    );
  }

  static String _string(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Missing or invalid $key.');
    }
    return value;
  }

  static int _int(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    throw FormatException('Missing or invalid $key.');
  }

  static double _double(Map<String, dynamic> json, String key) {
    final parsed = double.tryParse(json[key].toString());
    if (parsed == null) throw FormatException('Missing or invalid $key.');
    return parsed;
  }
}

class HotelImages {
  const HotelImages({
    required this.small,
    required this.medium,
    required this.large,
  });
  final String small;
  final String medium;
  final String large;
  factory HotelImages.fromJson(Map<String, dynamic> json) => HotelImages(
    small: Hotel._string(json, 'small'),
    medium: Hotel._string(json, 'medium'),
    large: Hotel._string(json, 'large'),
  );
}
