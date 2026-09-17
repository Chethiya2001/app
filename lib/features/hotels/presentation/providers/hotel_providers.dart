import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/remote_hotel_repository.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/repositories/hotel_repository.dart';

final hotelRepositoryProvider = Provider<HotelRepository>(
  (ref) => RemoteHotelRepository(),
);
final hotelsProvider = FutureProvider<List<Hotel>>(
  (ref) => ref.watch(hotelRepositoryProvider).fetchHotels(),
);
