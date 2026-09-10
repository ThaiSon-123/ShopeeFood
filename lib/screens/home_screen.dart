import 'package:app_shopeefood/data/shopee_food_data.dart';
import 'package:app_shopeefood/screens/account_screen.dart';
import 'package:app_shopeefood/screens/order_tracking_screen.dart';
import 'package:app_shopeefood/screens/restaurant_detail_screen.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategory;
  RestaurantFilter _selectedFilter = RestaurantFilter.nearby;

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedFilter = RestaurantFilter.nearby;
    });
    _showHomeAction(context, 'Đang xem danh mục $category');
  }

  void _showAllRestaurants() {
    setState(() {
      _selectedCategory = null;
      _selectedFilter = RestaurantFilter.nearby;
    });
    _showHomeAction(context, 'Đã hiển thị tất cả món ăn');
  }

  void _selectFilter(RestaurantFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _showHomeAction(context, 'Đang lọc theo ${filter.label}');
  }

  @override
  Widget build(BuildContext context) {
    final topSafeArea = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topSafeArea + 56, 0, 98),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _AddressBar(),
                    const SizedBox(height: 16),
                    const _SearchBar(),
                    const SizedBox(height: 20),
                    const _PromoBanner(),
                    const SizedBox(height: 20),
                    _CategorySection(
                      selectedCategory: _selectedCategory,
                      onCategoryTap: _selectCategory,
                      onShowAll: _showAllRestaurants,
                    ),
                    const SizedBox(height: 22),
                    _NearbySection(
                      selectedCategory: _selectedCategory,
                      selectedFilter: _selectedFilter,
                      onFilterTap: _selectFilter,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: AppTopHeader(
              showTitle: false,
              onNotificationPressed: () =>
                  _showHomeAction(context, 'Bạn chưa có thông báo mới'),
              onProfilePressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AccountScreen(),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ShopeeBottomNav(
              activeIndex: 0,
              onTap: (index) => _handleBottomNav(context, index),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBottomNav(BuildContext context, int index) {
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const OrderTrackingScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const AccountScreen()));
    }
  }
}

class _AddressBar extends StatelessWidget {
  const _AddressBar();

  @override
  Widget build(BuildContext context) {
    final state = ShopeeFoodScope.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: InkWell(
        onTap: () => _showAddressPicker(context),
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xffffdbce),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Giao đến',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.muted,
                        size: 14,
                      ),
                    ],
                  ),
                  Text(
                    state.selectedAddress.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.softControl,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Tìm món ăn, quán ăn...',
                    style: TextStyle(
                      color: AppColors.muted.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _RoundAction(
            icon: Icons.photo_camera_outlined,
            message: 'Đã mở tìm kiếm bằng hình ảnh',
          ),
          const SizedBox(width: 8),
          _RoundAction(
            icon: Icons.tune_rounded,
            message: 'Đã mở bộ lọc tìm kiếm',
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showHomeAction(context, message),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.softControl,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.text, size: 19),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 148,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xffd63c1e), AppColors.accent],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -42,
              top: -50,
              child: Container(
                width: 144,
                height: 144,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _PromoPill(),
                      const SizedBox(height: 4),
                      const Text(
                        'Freeship Hôm Nay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text.rich(
                        TextSpan(
                          text: 'Giảm đến ',
                          children: [
                            TextSpan(
                              text: '50%',
                              style: TextStyle(
                                color: Color(0xfffde047),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(text: ' • Không lo tiền\nship'),
                          ],
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.34,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const _PromoButton(),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Transform.rotate(
                      angle: 0.035,
                      child: Container(
                        width: 112,
                        height: 104,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: const AppAssetImage(
                          AppAssets.promoDish,
                          fit: BoxFit.cover,
                          fallback: AppImageFallback(label: '-50%'),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -8,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xfffacc15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '-50%',
                          style: TextStyle(
                            color: Color(0xff5e1d00),
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            height: 1.27,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoPill extends StatelessWidget {
  const _PromoPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(
            'ƯU ĐÃI ĐẶC QUYỀN',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoButton extends StatelessWidget {
  const _PromoButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showHomeAction(context, 'Đã lưu mã freeship hôm nay'),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lấy mã ngay',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1.33,
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.primary,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.onShowAll,
  });

  final String? selectedCategory;
  final ValueChanged<String> onCategoryTap;
  final VoidCallback onShowAll;

  static const categories = [
    _Category('Cơm', AppAssets.categoryRice),
    _Category('Trà sữa', AppAssets.categoryTea),
    _Category('Bún / Phở', AppAssets.categoryNoodles),
    _Category('Gà rán', AppAssets.categoryChicken),
    _Category('Đồ uống', AppAssets.categoryDrink),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Khám phá danh mục',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.38,
                ),
              ),
              TextButton(
                onPressed: onShowAll,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1.27,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 90,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = categories[index];
              final active = selectedCategory == item.label;

              return InkWell(
                onTap: () => onCategoryTap(item.label),
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 64,
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xffffdbce)
                              : const Color(0xffffdbce).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: active
                              ? Border.all(color: AppColors.primary, width: 1.5)
                              : null,
                        ),
                        child: ClipOval(
                          child: AppAssetImage(
                            item.image,
                            fit: BoxFit.cover,
                            fallback: const AppImageFallback(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: active ? AppColors.primary : AppColors.text,
                          fontSize: 11,
                          fontWeight: active
                              ? FontWeight.w800
                              : FontWeight.w600,
                          height: 1.27,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NearbySection extends StatelessWidget {
  const _NearbySection({
    required this.selectedCategory,
    required this.selectedFilter,
    required this.onFilterTap,
  });

  final String? selectedCategory;
  final RestaurantFilter selectedFilter;
  final ValueChanged<RestaurantFilter> onFilterTap;

  @override
  Widget build(BuildContext context) {
    final visibleRestaurants = _visibleRestaurants();
    final sectionTitle = switch (selectedFilter) {
      RestaurantFilter.topRated => 'Top đánh giá',
      RestaurantFilter.promotion => 'Đang khuyến mãi',
      RestaurantFilter.nearby => selectedCategory == null
          ? 'Quán gần bạn'
          : 'Món $selectedCategory gần bạn',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.near_me_outlined,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sectionTitle,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.38,
                  ),
                ),
              ),
              Text(
                '${visibleRestaurants.length} lựa chọn',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in RestaurantFilter.values) ...[
                  _FilterChip(
                    label: filter.label,
                    active: selectedFilter == filter,
                    icon: switch (filter) {
                      RestaurantFilter.nearby => Icons.directions_walk,
                      RestaurantFilter.topRated => Icons.star_rounded,
                      RestaurantFilter.promotion => Icons.local_offer_outlined,
                    },
                    onTap: () => onFilterTap(filter),
                  ),
                  if (filter != RestaurantFilter.values.last)
                    const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...visibleRestaurants.map(
            (restaurant) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RestaurantCard(restaurant: restaurant),
            ),
          ),
        ],
      ),
    );
  }

  List<Restaurant> _visibleRestaurants() {
    final restaurants = selectedCategory == null
        ? demoRestaurants
        : demoRestaurants
              .where((restaurant) => restaurant.category == selectedCategory)
              .toList();
    final filtered = switch (selectedFilter) {
      RestaurantFilter.nearby => restaurants,
      RestaurantFilter.topRated => restaurants
          .where((restaurant) => restaurant.rating >= 4.8)
          .toList(),
      RestaurantFilter.promotion => restaurants
          .where((restaurant) => restaurant.hasPromotion)
          .toList(),
    };

    return List<Restaurant>.from(filtered)
      ..sort((left, right) {
        if (selectedFilter == RestaurantFilter.topRated) {
          return right.rating.compareTo(left.rating);
        }
        if (selectedFilter == RestaurantFilter.nearby &&
            left.selected != right.selected) {
          return left.selected ? -1 : 1;
        }
        return left.distanceKm.compareTo(right.distanceKm);
      });
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.active = false,
    this.icon,
    this.onTap,
  });

  final String label;
  final bool active;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 13,
                color: active ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : AppColors.text,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.27,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: restaurant.selected
                  ? Border.all(color: AppColors.primary, width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RestaurantImage(restaurant: restaurant),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 88,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                if (restaurant.partner) ...[
                                  const _PartnerBadge(),
                                  const SizedBox(width: 6),
                                ],
                                Expanded(
                                  child: Text(
                                    restaurant.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.text,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  restaurant.distanceLabel,
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 13,
                                    height: 1.38,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    '•',
                                    style: TextStyle(color: AppColors.muted),
                                  ),
                                ),
                                const Icon(
                                  Icons.access_time_rounded,
                                  color: AppColors.success,
                                  size: 13,
                                ),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    restaurant.etaLabel,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.success,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      height: 1.38,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: restaurant.tags
                              .map((tag) => _Tag(label: tag))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (restaurant.selected)
            Positioned(
              right: 14,
              top: -8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 10),
                    SizedBox(width: 3),
                    Text(
                      'Đang chọn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RestaurantImage extends StatelessWidget {
  const _RestaurantImage({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        color: AppColors.softControl,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppAssetImage(
            restaurant.image,
            fit: BoxFit.cover,
            fallback: AppImageFallback(label: restaurant.ratingLabel),
          ),
          Positioned(
            left: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xffffd15c),
                    size: 10,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    restaurant.ratingLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerBadge extends StatelessWidget {
  const _PartnerBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xffffdad3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Đối tác',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final lower = label.toLowerCase();
    final isFreeShip = lower.contains('freeship');
    final isDiscount = lower.contains('giảm') || lower.contains('mua');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isFreeShip
            ? const Color(0xff71fe91)
            : isDiscount
            ? const Color(0xffffdbce)
            : AppColors.softControl,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isFreeShip
              ? const Color(0xff005321)
              : isDiscount
              ? AppColors.warm
              : AppColors.muted,
          fontSize: 10,
          fontWeight: isFreeShip || isDiscount
              ? FontWeight.w800
              : FontWeight.w500,
          height: 1.2,
        ),
      ),
    );
  }
}

class _Category {
  const _Category(this.label, this.image);

  final String label;
  final String image;
}

void _showAddressPicker(BuildContext context) {
  final state = ShopeeFoodScope.of(context);

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn địa chỉ giao hàng',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              for (final address in demoAddresses)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    state.selectedAddress.id == address.id
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    address.label,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(address.address),
                  onTap: () {
                    state.selectAddress(address);
                    Navigator.of(sheetContext).pop();
                    _showHomeAction(context, 'Đã đổi địa chỉ giao hàng');
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

void _showHomeAction(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
}
