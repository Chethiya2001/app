import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/hotel.dart';
import '../../domain/repositories/hotel_repository.dart';

class RemoteHotelRepository implements HotelRepository {
  RemoteHotelRepository({http.Client? client})
    : _client = client ?? http.Client();

  static final Uri endpoint = Uri.parse(
    'https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json',
  );
  static const _requestTimeout = Duration(seconds: 15);

  final http.Client _client;

  @override
  Future<List<Hotel>> fetchHotels() async {
    final response = await _client
        .get(endpoint, headers: const {'Content-Type': 'application/json'})
        .timeout(_requestTimeout);

    if (response.statusCode != 200) {
      throw HotelApiException(
        'Request failed with status ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected hotels response.');
    }

    final data = decoded['data'];
    if (decoded['status'] != 200 || data is! List) {
      throw const FormatException('Unexpected hotels response.');
    }

    return List.unmodifiable(
      data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid hotel entry.');
        }
        return Hotel.fromJson(item);
      }),
    );
  }
}

class HotelApiException implements Exception {
  const HotelApiException(this.message);
  final String message;

  @override
  String toString() => 'HotelApiException: $message';
}
