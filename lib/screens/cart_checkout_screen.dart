import 'dart:ui';

import 'package:app_shopeefood/screens/account_screen.dart';
import 'package:app_shopeefood/screens/order_tracking_screen.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';

class CartCheckoutScreen extends StatelessWidget {
  const CartCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topSafeArea = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topSafeArea + 100, 0, 118),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8),
                    _DeliveryPromise(),
                    SizedBox(height: 12),
                    _AddressCard(),
                    SizedBox(height: 14),
                    _RestaurantTitle(),
                    SizedBox(height: 8),
                    _OrderItemsList(),
                    SizedBox(height: 12),
                    _OrderNoteField(),
                    SizedBox(height: 12),
                    _VoucherCard(),
                    SizedBox(height: 12),
                    _PaymentMethodsCard(),
                    SizedBox(height: 12),
                    _BillSummaryCard(),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(left: 0, right: 0, top: 0, child: _CheckoutHeader()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _CheckoutBottomBar(
              onOrder: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const OrderTrackingScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutHeader extends StatelessWidget {
  const _CheckoutHeader();

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
                          onPressed: () => _showCheckoutAction(
                            context,
                            'Đã chia sẻ đơn hàng',
                          ),
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

class _DeliveryPromise extends StatelessWidget {
  const _DeliveryPromise();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _SoftPanel(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.timer_rounded, color: AppColors.primary, size: 17),
            SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'Giao siêu tốc dự kiến ',
                  children: [
                    TextSpan(
                      text: '20 - 25 phút',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
            ),
            SizedBox(width: 8),
            _StatusPill(
              label: 'Đúng giờ',
              color: AppColors.success,
              background: Color(0xff71fe91),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TintIcon(icon: Icons.location_on_rounded, round: true),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Địa chỉ nhận món',
                        style: TextStyle(
                          color: Color(0xffa73a00),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          height: 1.27,
                        ),
                      ),
                      SizedBox(width: 6),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: 6, height: 6),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    '123 Nguyễn Văn Cừ, P.4, Q.5',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.38,
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Nguyễn Thu Hà • 0901 234 567',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                      height: 1.38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () =>
                  _showCheckoutAction(context, 'Đã chọn thay đổi địa chỉ'),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.softControl,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Thay đổi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantTitle extends StatelessWidget {
  const _RestaurantTitle();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _TintIcon(
            icon: Icons.storefront_rounded,
            size: 24,
            iconSize: 14,
            round: false,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cơm Tấm Phúc Lộc Thọ',
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
          SizedBox(width: 8),
          Icon(Icons.verified_rounded, color: AppColors.success, size: 13),
          SizedBox(width: 3),
          Text(
            'Quán Đối Tác',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  const _OrderItemsList();

  static const items = [
    _CheckoutItem(
      name: 'Cơm tấm sườn bì chả',
      description: 'Sườn nướng mềm, mỡ hành thơm lừng',
      price: '45.000đ',
      image: AppAssets.restaurantRice,
    ),
    _CheckoutItem(
      name: 'Cơm sườn trứng',
      description: 'Trứng ốp la lòng đào béo ngậy',
      price: '50.000đ',
      image: AppAssets.promoDish,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (final item in items) ...[
            _CheckoutItemCard(item: item),
            if (item != items.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _CheckoutItemCard extends StatelessWidget {
  const _CheckoutItemCard({required this.item});

  final _CheckoutItem item;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 64,
              height: 64,
              child: AppAssetImage(
                item.image,
                fit: BoxFit.cover,
                fallback: AppImageFallback(label: item.price),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          height: 1.47,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.muted,
                      size: 18,
                    ),
                  ],
                ),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.price,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const _QuantityStepper(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.softControl,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CircleIcon(
            icon: Icons.remove_rounded,
            background: AppColors.divider,
            foreground: AppColors.muted,
            onTap: () => _showCheckoutAction(context, 'Đã giảm số lượng món'),
          ),
          const SizedBox(width: 10),
          const SizedBox(
            width: 12,
            child: Text(
              '1',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _CircleIcon(
            icon: Icons.add_rounded,
            background: AppColors.logoOrange,
            foreground: Colors.white,
            onTap: () => _showCheckoutAction(context, 'Đã tăng số lượng món'),
          ),
        ],
      ),
    );
  }
}

class _OrderNoteField extends StatelessWidget {
  const _OrderNoteField();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.notes_rounded, color: AppColors.muted, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Thêm ghi chú cho quán (ví dụ: ít mỡ hành, ớt riêng...)',
                maxLines: 2,
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
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const _TintIcon(
              icon: Icons.confirmation_number_rounded,
              size: 32,
              iconSize: 17,
              round: false,
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'SHOPEEFOOD20',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            height: 1.33,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      _DiscountBadge(),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.success,
                        size: 12,
                      ),
                      SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          'Áp dụng thành công ưu đãi bạn mới',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () =>
                  _showCheckoutAction(context, 'Đã chọn đổi mã giảm giá'),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Text(
                  'Đổi mã',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xffffdad3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        '-20.000đ',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PaymentMethodsCard extends StatelessWidget {
  const _PaymentMethodsCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phương thức thanh toán',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.38,
              ),
            ),
            SizedBox(height: 10),
            _PaymentOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Ví ShopeePay / Ví điện tử',
              subtitle: 'Khuyên dùng • Miễn phí thanh toán',
              selected: true,
            ),
            SizedBox(height: 8),
            _PaymentOption(
              icon: Icons.payments_outlined,
              title: 'Tiền mặt khi nhận hàng (COD)',
              subtitle: 'Chuẩn bị tiền mặt vừa đủ',
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: selected ? AppColors.field : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _CircleIcon(
            icon: icon,
            size: 28,
            iconSize: 15,
            background: selected ? AppColors.accent : AppColors.divider,
            foreground: selected ? Colors.white : AppColors.muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    height: 1.38,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? AppColors.success : AppColors.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _CircleIcon(
            icon: selected ? Icons.check_rounded : null,
            size: 20,
            iconSize: 14,
            background: selected ? AppColors.primary : AppColors.divider,
            foreground: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _BillSummaryCard extends StatelessWidget {
  const _BillSummaryCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chi tiết thanh toán',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.38,
              ),
            ),
            SizedBox(height: 10),
            _BillRow(label: 'Tạm tính (2 món)', value: '95.000đ'),
            SizedBox(height: 8),
            _BillRow(
              label: 'Phí giao hàng (1.2 km)',
              value: '16.000đ',
              icon: Icons.info_outline_rounded,
            ),
            SizedBox(height: 8),
            _BillRow(
              label: 'Giảm giá voucher',
              value: '-20.000đ',
              highlight: true,
            ),
            SizedBox(height: 8),
            _BillRow(label: 'Phí dịch vụ', value: '3.000đ'),
            SizedBox(height: 10),
            _TotalPanel(),
          ],
        ),
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  const _BillRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.icon,
  });

  final String label;
  final String value;
  final bool highlight;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.primary : AppColors.muted;
    final valueColor = highlight ? AppColors.primary : AppColors.text;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
                    height: 1.38,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, color: AppColors.muted, size: 13),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w500,
            height: 1.38,
          ),
        ),
      ],
    );
  }
}

class _TotalPanel extends StatelessWidget {
  const _TotalPanel();

  @override
  Widget build(BuildContext context) {
    return const _SoftPanel(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng thanh toán',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.38,
                  ),
                ),
                Text(
                  'Đã bao gồm thuế & phí nền tảng',
                  style: TextStyle(
                    color: Color(0xff8f7069),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '94.000đ',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBottomBar extends StatelessWidget {
  const _CheckoutBottomBar({required this.onOrder});

  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 398),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tổng thanh toán',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            '94.000đ',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                          Text(
                            'Tiết kiệm 20.000đ',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 168,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: onOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đặt hàng',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
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
      child: child,
    );
  }
}

class _SoftPanel extends StatelessWidget {
  const _SoftPanel({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _TintIcon extends StatelessWidget {
  const _TintIcon({
    required this.icon,
    this.size = 32,
    this.iconSize = 18,
    this.round = true,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final bool round;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xffffdbce),
        borderRadius: BorderRadius.circular(round ? 999 : 6),
      ),
      child: Icon(icon, color: AppColors.primary, size: iconSize),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    required this.background,
    required this.foreground,
    this.icon,
    this.size = 24,
    this.iconSize = 15,
    this.onTap,
  });

  final IconData? icon;
  final Color background;
  final Color foreground;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: icon == null
            ? null
            : Icon(icon, color: foreground, size: iconSize),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
  }
}

class _CheckoutItem {
  const _CheckoutItem({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  final String name;
  final String description;
  final String price;
  final String image;
}

void _showCheckoutAction(BuildContext context, String message) {
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
