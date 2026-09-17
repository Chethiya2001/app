import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/hotel.dart';

class HotelMapScreen extends StatelessWidget {
  const HotelMapScreen({required this.hotel, super.key});
  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    final location = LatLng(hotel.latitude, hotel.longitude);
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: FlutterMap(
        options: MapOptions(initialCenter: location, initialZoom: 7),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.hotel_explorer',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: location,
                width: 250,
                height: 110,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          hotel.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.location_pin,
                      size: 42,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const RichAttributionWidget(
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
    );
  }
}
