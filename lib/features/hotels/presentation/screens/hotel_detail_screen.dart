import 'package:flutter/material.dart';
import '../../domain/entities/hotel.dart';
import '../widgets/hotel_image.dart';
import 'hotel_map_screen.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({required this.hotel, super.key});
  final Hotel hotel;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Hotel details'),
      actions: [
        IconButton(
          tooltip: 'Show on map',
          icon: const Icon(Icons.map_outlined),
          onPressed: () => _openMap(context),
        ),
      ],
    ),
    body: ListView(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Hero(
            tag: 'hotel-${hotel.id}',
            child: HotelImage(url: hotel.images.large, hotelId: hotel.id),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              _InfoRow(icon: Icons.location_on_outlined, text: hotel.address),
              const SizedBox(height: 10),
              _InfoRow(icon: Icons.phone_outlined, text: hotel.phoneNumber),
              const SizedBox(height: 28),
              Text(
                'About this hotel',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Text(
                hotel.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(height: 1.55),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => _openMap(context),
                icon: const Icon(Icons.map_outlined),
                label: const Text('View on map'),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  void _openMap(BuildContext context) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => HotelMapScreen(hotel: hotel)));
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 21, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 10),
      Expanded(child: Text(text)),
    ],
  );
}
