import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HotelImage extends StatelessWidget {
  const HotelImage({required this.url, required this.hotelId, super.key});
  final String url;
  final int hotelId;

  @override
  Widget build(BuildContext context) {
    // The feed contains obsolete HTTP lorempixel URLs. Try HTTPS first and use
    // a stable per-hotel fallback if that legacy host is unavailable.
    final secureUrl = url.replaceFirst(RegExp(r'^http://'), 'https://');
    return CachedNetworkImage(
      imageUrl: secureUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (_, _, _) => Image.network(
        'https://picsum.photos/seed/hotel-$hotelId/900/600',
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(child: Icon(Icons.hotel_rounded, size: 40)),
        ),
      ),
    );
  }
}
