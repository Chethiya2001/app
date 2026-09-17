import 'package:app/features/hotels/domain/entities/hotel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Hotel parses the API response format', () {
    final hotel = Hotel.fromJson({
      'id': 1,
      'title': 'Test Hotel',
      'description': 'A useful description',
      'address': '1 Main Street',
      'postcode': '12345',
      'phoneNumber': '555-0100',
      'latitude': '-60.5',
      'longitude': '12.25',
      'image': {
        'small': 'http://example.com/s.jpg',
        'medium': 'http://example.com/m.jpg',
        'large': 'http://example.com/l.jpg',
      },
    });
    expect(hotel.id, 1);
    expect(hotel.latitude, -60.5);
    expect(hotel.images.large, endsWith('l.jpg'));
  });

  test('Hotel rejects malformed coordinates', () {
    expect(
      () => Hotel.fromJson({
        'id': 1,
        'title': 'Test',
        'description': 'Description',
        'address': 'Address',
        'postcode': '123',
        'phoneNumber': '555',
        'latitude': 'not-a-number',
        'longitude': '1',
        'image': {'small': 's', 'medium': 'm', 'large': 'l'},
      }),
      throwsFormatException,
    );
  });
}
