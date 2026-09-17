import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/widgets/async_error_view.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/hotel.dart';
import 'hotel_detail_screen.dart';
import '../widgets/hotel_image.dart';
import '../providers/hotel_providers.dart';

class HotelListScreen extends ConsumerWidget {
  const HotelListScreen({required this.account, super.key});
  final GoogleSignInAccount account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotels = ref.watch(hotelsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discover hotels',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(
              'Find a place worth remembering',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Account menu',
            icon: CircleAvatar(
              foregroundImage: account.photoUrl == null
                  ? null
                  : NetworkImage(account.photoUrl!),
              child: account.photoUrl == null ? const Icon(Icons.person) : null,
            ),
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authControllerProvider.notifier).signOut();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(enabled: false, child: Text(account.email)),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'logout', child: Text('Sign out')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(hotelsProvider.future),
        child: hotels.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .7,
                child: AsyncErrorView(
                  onRetry: () => ref.invalidate(hotelsProvider),
                ),
              ),
            ],
          ),
          data: (items) => items.isEmpty
              ? const Center(child: Text('No hotels are available right now.'))
              : ListView.separated(
                  key: const Key('hotel-list'),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _HotelCard(hotel: items[index]),
                ),
        ),
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  const _HotelCard({required this.hotel});
  final Hotel hotel;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)),
      ),
      child: SizedBox(
        height: 124,
        child: Row(
          children: [
            SizedBox(
              width: 124,
              height: double.infinity,
              child: Hero(
                tag: 'hotel-${hotel.id}',
                child: HotelImage(url: hotel.images.small, hotelId: hotel.id),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotel.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 17),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel.address.replaceAll('\n', ', '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    ),
  );
}
