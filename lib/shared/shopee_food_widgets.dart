import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xfffaf8fe);
  static const surface = Color(0xffffffff);
  static const field = Color(0xfff4f3f8);
  static const logoOrange = Color(0xffee4d2d);
  static const primary = Color(0xffb22204);
  static const accent = Color(0xfffc7135);
  static const text = Color(0xff1a1b1f);
  static const muted = Color(0xff5b403b);
  static const warm = Color(0xff802a00);
  static const divider = Color(0xffe3e2e7);
  static const softControl = Color(0xffeeedf3);
  static const success = Color(0xff006b2d);
}

class AppAssets {
  static const hero = 'assets/images/login_hero.jpeg';
  static const profile = 'assets/images/avatar.png';
  static const categoryRice = 'assets/images/home_05.jpeg';
  static const categoryTea = 'assets/images/home_03.jpeg';
  static const categoryNoodles = 'assets/images/home_06.jpeg';
  static const categoryChicken = 'assets/images/home_01.jpeg';
  static const categoryDrink = 'assets/images/home_02.jpeg';
  static const home01 = 'assets/images/home_01.jpeg';
  static const home02 = 'assets/images/home_02.jpeg';
  static const home07 = 'assets/images/home_07.jpeg';
  static const home10 = 'assets/images/home_10.jpeg';
  static const home11 = 'assets/images/home_11.jpeg';
  static const home12 = 'assets/images/home_12.jpeg';
  static const promoDish = 'assets/images/home_04.jpeg';
  static const restaurantRice = 'assets/images/home_05.jpeg';
  static const restaurantTea = 'assets/images/home_03.jpeg';
  static const restaurantNoodles = 'assets/images/home_06.jpeg';
}

class ShopeeFoodLogo extends StatelessWidget {
  const ShopeeFoodLogo({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textSize = height * 0.42;

    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LogoMark(size: height),
          SizedBox(width: height * 0.16),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: const [
                    TextSpan(
                      text: 'Shopee',
                      style: TextStyle(color: AppColors.logoOrange),
                    ),
                    TextSpan(
                      text: 'Food',
                      style: TextStyle(color: AppColors.text),
                    ),
                  ],
                ),
                maxLines: 1,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.logoOrange,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Icon(
        Icons.shopping_bag_outlined,
        color: Colors.white,
        size: size * 0.58,
      ),
    );
  }
}

class AppAssetImage extends StatelessWidget {
  const AppAssetImage(
    this.asset, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.fallback,
  });

  final String asset;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? const AppImageFallback();
      },
    );
  }
}

class AppImageFallback extends StatelessWidget {
  const AppImageFallback({
    super.key,
    this.icon = Icons.restaurant_rounded,
    this.label,
  });

  final IconData icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffffece6), Color(0xffeeedf3)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.warm,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppStatusRow extends StatelessWidget {
  const AppStatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 44,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '9:41',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                height: 1.33,
              ),
            ),
            Row(
              children: [
                Icon(Icons.signal_cellular_alt_rounded, size: 15),
                SizedBox(width: 8),
                Icon(Icons.wifi_rounded, size: 16),
                SizedBox(width: 8),
                Icon(Icons.battery_full_rounded, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppTopHeader extends StatelessWidget {
  const AppTopHeader({
    super.key,
    this.showTitle = true,
    this.onNotificationPressed,
    this.onProfilePressed,
  });

  final bool showTitle;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;

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
                        const ShopeeFoodLogo(width: 86, height: 32),
                        if (showTitle) ...[
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ShopeeFood',
                                  style: TextStyle(
                                    color: AppColors.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    height: 1.25,
                                  ),
                                ),
                                Text(
                                  'Trang Chủ',
                                  style: TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    height: 1.27,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else
                          const Spacer(),
                        IconButton(
                          onPressed: onNotificationPressed,
                          style: IconButton.styleFrom(
                            fixedSize: const Size(44, 44),
                            minimumSize: const Size(44, 44),
                            padding: EdgeInsets.zero,
                          ),
                          icon: const Icon(Icons.notifications_none_rounded),
                          color: AppColors.text,
                          tooltip: 'Thông báo',
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: onProfilePressed,
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

class ShopeeBottomNav extends StatelessWidget {
  const ShopeeBottomNav({super.key, required this.activeIndex, this.onTap});

  final int activeIndex;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: _BottomNavItem(
                      icon: Icons.storefront_outlined,
                      label: 'Trang chủ',
                      active: activeIndex == 0,
                      onTap: () => onTap?.call(0),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavItem(
                      icon: Icons.receipt_long_outlined,
                      label: 'Đơn hàng',
                      active: activeIndex == 1,
                      onTap: () => onTap?.call(1),
                    ),
                  ),
                  Expanded(
                    child: _BottomNavItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Tài khoản',
                      active: activeIndex == 2,
                      onTap: () => onTap?.call(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.muted;

    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  height: 1.27,
                ),
              ),
            ],
          ),
          if (active)
            Positioned(
              bottom: 4,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
