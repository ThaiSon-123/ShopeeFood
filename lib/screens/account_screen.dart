import 'dart:ui';

import 'package:app_shopeefood/data/shopee_food_data.dart';
import 'package:app_shopeefood/screens/home_screen.dart';
import 'package:app_shopeefood/screens/login_screen.dart';
import 'package:app_shopeefood/screens/order_tracking_screen.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topSafeArea = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: ShopeeBottomNav(
        activeIndex: 2,
        onTap: (index) => _handleBottomNav(context, index),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, topSafeArea + 64, 16, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ProfileCard(),
                    const SizedBox(height: 14),
                    const _StatsRow(),
                    const SizedBox(height: 14),
                    const _AccountMenu(),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(left: 0, right: 0, top: 0, child: _AccountHeader()),
        ],
      ),
    );
  }

  void _handleBottomNav(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const OrderTrackingScreen()),
      );
    }
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader();

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: IconButton.styleFrom(
                            fixedSize: const Size(44, 44),
                            minimumSize: const Size(44, 44),
                            padding: EdgeInsets.zero,
                          ),
                          icon: const Icon(Icons.arrow_back_rounded, size: 20),
                          color: AppColors.text,
                          tooltip: 'Quay lại',
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Tài khoản',
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
                        IconButton(
                          onPressed: () =>
                              _showAction(context, 'Đã mở cài đặt tài khoản'),
                          style: IconButton.styleFrom(
                            fixedSize: const Size(44, 44),
                            minimumSize: const Size(44, 44),
                            padding: EdgeInsets.zero,
                          ),
                          icon: const Icon(Icons.settings_outlined, size: 20),
                          color: AppColors.text,
                          tooltip: 'Cài đặt',
                        ),
                        const SizedBox(width: 8),
                        const SizedBox(
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xffffdbce),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: const AppAssetImage(
              AppAssets.profile,
              fallback: AppImageFallback(icon: Icons.person_rounded),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Võ Thái Sơn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '2324801030030',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.28,
                  ),
                ),
                SizedBox(height: 8),
                _MemberBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberBadge extends StatelessWidget {
  const _MemberBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xffffdad3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, color: AppColors.primary, size: 13),
          SizedBox(width: 4),
          Text(
            'ShopeeFood member',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(value: '12', label: 'Đơn hàng'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '94k', label: 'Đơn gần nhất'),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(value: '20k', label: 'Đã tiết kiệm'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountMenu extends StatelessWidget {
  const _AccountMenu();

  @override
  Widget build(BuildContext context) {
    final state = ShopeeFoodScope.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.receipt_long_outlined,
            title: 'Đơn hàng của tôi',
            subtitle: 'Theo dõi đơn đang giao và lịch sử đặt món',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const OrderTrackingScreen(),
                ),
              );
            },
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.location_on_outlined,
            title: 'Địa chỉ giao hàng',
            subtitle: state.selectedAddress.address,
            onTap: () => _showAddressPicker(context),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Ví ShopeePay',
            subtitle: 'Phương thức thanh toán đang dùng',
            onTap: () => _showAction(context, 'Đã chọn Ví ShopeePay'),
          ),
          const _MenuDivider(),
          _MenuTile(
            icon: Icons.logout_rounded,
            title: 'Đăng xuất',
            subtitle: 'Quay lại màn hình đăng nhập',
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => const ShopeeFoodLoginScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xffffdad3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      height: 1.28,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      height: 1.27,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 62, color: AppColors.divider);
  }
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
                    _showAction(context, 'Đã đổi địa chỉ giao hàng');
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

void _showAction(BuildContext context, String message) {
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
