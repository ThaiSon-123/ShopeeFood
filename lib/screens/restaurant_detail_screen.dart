import 'dart:ui';

import 'package:app_shopeefood/screens/account_screen.dart';
import 'package:app_shopeefood/screens/cart_checkout_screen.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topSafeArea = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topSafeArea + 100, 0, 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroAndInfo(),
                    _MenuTabs(),
                    SizedBox(height: 12),
                    _PopularDishSection(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 0, right: 0, top: 0, child: const _DetailHeader()),
          Positioned(
            left: 16,
            right: 16,
            top: topSafeArea + 88,
            child: const _CheckoutSummary(),
          ),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const AppStatusRow(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        _HeaderIconButton(
                          icon: Icons.arrow_back_rounded,
                          tooltip: 'Quay lại',
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Chi Tiết Quán Ăn',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.38,
                            ),
                          ),
                        ),
                        _HeaderIconButton(
                          icon: Icons.share_outlined,
                          tooltip: 'Chia sẻ',
                          onPressed: () =>
                              _showDetailAction(context, 'Đã chia sẻ quán ăn'),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const AccountScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: ClipOval(
                                  child: AppAssetImage(
                                    AppAssets.profile,
                                    fallback: AppImageFallback(
                                      icon: Icons.person_rounded,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        fixedSize: const Size(44, 44),
        minimumSize: const Size(44, 44),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(icon, size: 20),
      color: AppColors.text,
      tooltip: tooltip,
    );
  }
}

class _CheckoutSummary extends StatelessWidget {
  const _CheckoutSummary();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 398),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xffffdad3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          '2 món',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.33,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '•',
                            style: TextStyle(color: Color(0xffe3beb6)),
                          ),
                        ),
                        Text(
                          '95.000đ',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Đã áp dụng mã giảm phí ship',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xff8f7069),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const CartCheckoutScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 7,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Xem giỏ hàng',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            height: 1.33,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroAndInfo extends StatelessWidget {
  const _HeroAndInfo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 224,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const AppAssetImage(
                  AppAssets.promoDish,
                  fit: BoxFit.cover,
                  fallback: AppImageFallback(label: 'Cơm tấm'),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.2),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 16,
            right: 16,
            top: 184,
            child: _RestaurantInfoCard(),
          ),
        ],
      ),
    );
  }
}

class _RestaurantInfoCard extends StatelessWidget {
  const _RestaurantInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cơm Tấm Phúc Lộc Thọ - Chi nhánh Quận 5',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _InfoMetric(
                icon: Icons.star_rounded,
                iconColor: Color(0xffff8a00),
                label: '4.8',
                note: '(500+ đánh giá)',
              ),
              _InfoMetric(
                icon: Icons.navigation_rounded,
                iconColor: AppColors.success,
                label: '1.2 km',
              ),
              _InfoMetric(
                icon: Icons.access_time_rounded,
                iconColor: AppColors.primary,
                label: '20 - 30 phút',
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color(0xff8f7069),
                size: 15,
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '123 Nguyễn Văn Cừ, Phường 4, Quận 5, TP.HCM',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff8f7069),
                    fontSize: 13,
                    height: 1.38,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              _DealTag(
                label: 'Mã giảm 20k',
                icon: Icons.confirmation_number_outlined,
                background: Color(0xffffdad3),
                foreground: Color(0xff3e0500),
              ),
              SizedBox(width: 8),
              _DealTag(
                label: 'Freeship 15k',
                icon: Icons.delivery_dining_rounded,
                background: Color(0xff71fe91),
                foreground: Color(0xff002109),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.note,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 13),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.38,
          ),
        ),
        if (note != null) ...[
          const SizedBox(width: 3),
          Text(
            note!,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

class _DealTag extends StatelessWidget {
  const _DealTag({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1.27,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTabs extends StatelessWidget {
  const _MenuTabs();

  static const tabs = ['Bán chạy', 'Cơm', 'Canh', 'Đồ uống', 'Món thêm'];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          color: AppColors.background.withValues(alpha: 0.95),
          child: SizedBox(
            height: 28,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final active = index == 0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        color: active ? AppColors.primary : AppColors.muted,
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: active ? 44 : 0,
                      height: 3,
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PopularDishSection extends StatelessWidget {
  const _PopularDishSection();

  static const dishes = [
    _Dish(
      name: 'Cơm tấm sườn bì chả',
      description: 'Sườn nướng đậm đà, chả trứng béo ngậy, bì giòn thơm.',
      price: '45.000đ',
      image: AppAssets.restaurantRice,
      selectedCount: 1,
      hot: true,
    ),
    _Dish(
      name: 'Cơm sườn trứng ốp la',
      description: 'Sườn cốt lết ướp mật ong nướng than hồng, trứng lòng đào.',
      price: '50.000đ',
      image: AppAssets.promoDish,
      selectedCount: 1,
    ),
    _Dish(
      name: 'Canh rong biển thịt bằm',
      description: 'Canh ngọt thanh mát, rong biển Hàn Quốc, thịt bằm tươi.',
      price: '20.000đ',
      image: AppAssets.restaurantNoodles,
    ),
    _Dish(
      name: 'Trà đào cam sả',
      description: 'Vị chua ngọt thanh mát giải nhiệt, miếng đào giòn.',
      price: '25.000đ',
      image: AppAssets.categoryDrink,
    ),
    _Dish(
      name: 'Cơm gà xối mỡ',
      description: 'Đùi gà da giòn, cơm chiên tỏi và nước mắm chua ngọt.',
      price: '48.000đ',
      image: AppAssets.home12,
      hot: true,
    ),
    _Dish(
      name: 'Bún bò Huế đặc biệt',
      description: 'Tô lớn nhiều thịt, chả cua, sa tế thơm cay vừa miệng.',
      price: '55.000đ',
      image: AppAssets.restaurantNoodles,
    ),
    _Dish(
      name: 'Gà rán sốt cay',
      description: 'Miếng gà giòn phủ sốt cay ngọt, ăn kèm salad bắp cải.',
      price: '39.000đ',
      image: AppAssets.home01,
    ),
    _Dish(
      name: 'Trà sữa trân châu đường đen',
      description: 'Sữa tươi béo nhẹ, trân châu mềm và kem cheese mặn.',
      price: '32.000đ',
      image: AppAssets.restaurantTea,
    ),
    _Dish(
      name: 'Sinh tố bơ sầu riêng',
      description: 'Bơ xay mịn cùng sầu riêng thơm béo, có thể chọn ít đường.',
      price: '35.000đ',
      image: AppAssets.home02,
    ),
    _Dish(
      name: 'Cơm thêm',
      description: 'Phần cơm trắng thêm cho bữa trưa no hơn.',
      price: '8.000đ',
      image: AppAssets.restaurantRice,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Món bán chạy nhất 🔥',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.38,
                  ),
                ),
              ),
              Text(
                '${dishes.length} món',
                style: const TextStyle(
                  color: Color(0xff8f7069),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...dishes.map(
            (dish) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DishCard(dish: dish),
            ),
          ),
        ],
      ),
    );
  }
}

class _DishCard extends StatelessWidget {
  const _DishCard({required this.dish});

  final _Dish dish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.38,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dish.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      height: 1.38,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dish.price,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                      ),
                      if (dish.selectedCount == null)
                        const _AddDishButton()
                      else
                        _DishStepper(count: dish.selectedCount!),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _DishImage(dish: dish),
        ],
      ),
    );
  }
}

class _DishImage extends StatelessWidget {
  const _DishImage({required this.dish});

  final _Dish dish;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppAssetImage(
              dish.image,
              fit: BoxFit.cover,
              fallback: AppImageFallback(label: dish.price),
            ),
            if (dish.hot)
              Positioned(
                left: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'Hot',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      height: 2.2,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DishStepper extends StatelessWidget {
  const _DishStepper({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffffdad3).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _TinyCircleButton(
            icon: Icons.remove_rounded,
            color: Colors.white,
            iconColor: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(
            '$count',
            style: const TextStyle(
              color: Color(0xff8d1600),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              height: 1.23,
            ),
          ),
          const SizedBox(width: 8),
          const _TinyCircleButton(
            icon: Icons.add_rounded,
            color: AppColors.primary,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _AddDishButton extends StatelessWidget {
  const _AddDishButton();

  @override
  Widget build(BuildContext context) {
    return const _TinyCircleButton(
      icon: Icons.add_rounded,
      color: AppColors.primary,
      iconColor: Colors.white,
      size: 28,
    );
  }
}

class _TinyCircleButton extends StatelessWidget {
  const _TinyCircleButton({
    required this.icon,
    required this.color,
    required this.iconColor,
    this.size = 24,
  });

  final IconData icon;
  final Color color;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: size * 0.58),
    );
  }
}

class _Dish {
  const _Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.selectedCount,
    this.hot = false,
  });

  final String name;
  final String description;
  final String price;
  final String image;
  final int? selectedCount;
  final bool hot;
}

void _showDetailAction(BuildContext context, String message) {
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
