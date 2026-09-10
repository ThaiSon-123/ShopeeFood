import 'dart:ui';

import 'package:app_shopeefood/data/shopee_food_data.dart';
import 'package:app_shopeefood/screens/account_screen.dart';
import 'package:app_shopeefood/screens/order_tracking_screen.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';

class CartCheckoutScreen extends StatelessWidget {
  const CartCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topSafeArea = MediaQuery.paddingOf(context).top;
    final state = ShopeeFoodScope.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topSafeArea + 56, 0, 118),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    _DeliveryPromise(state: state),
                    const SizedBox(height: 12),
                    const _AddressCard(),
                    const SizedBox(height: 14),
                    if (state.cartRestaurant == null)
                      const _EmptyCartCard()
                    else ...[
                      _RestaurantTitle(restaurant: state.cartRestaurant!),
                      const SizedBox(height: 8),
                      _OrderItemsList(items: state.cartItems),
                      const SizedBox(height: 12),
                      const _OrderNoteField(),
                      const SizedBox(height: 12),
                      _VoucherCard(discount: state.voucherDiscount),
                      const SizedBox(height: 12),
                      const _PaymentMethodsCard(),
                      const SizedBox(height: 12),
                      _BillSummaryCard(state: state),
                    ],
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
              state: state,
              onOrder: () {
                state.placeOrder();
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
                            'Giỏ hàng & Thanh toán',
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
  const _DeliveryPromise({required this.state});

  final ShopeeFoodState state;

  @override
  Widget build(BuildContext context) {
    final eta = state.cartRestaurant?.etaLabel ?? '20-25 phút';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SoftPanel(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.timer_rounded, color: AppColors.primary, size: 17),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'Giao siêu tốc dự kiến ',
                  children: [
                    TextSpan(
                      text: eta,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const _StatusPill(
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
    final state = ShopeeFoodScope.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TintIcon(icon: Icons.location_on_rounded, round: true),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
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
                  const SizedBox(height: 2),
                  Text(
                    state.selectedAddress.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.38,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    state.selectedAddress.contactLine,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
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
              onPressed: () => _showAddressPicker(context),
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
  const _RestaurantTitle({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const _TintIcon(
            icon: Icons.storefront_rounded,
            size: 24,
            iconSize: 14,
            round: false,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              restaurant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.38,
              ),
            ),
          ),
          if (restaurant.partner) ...[
            const SizedBox(width: 8),
            const Icon(Icons.verified_rounded, color: AppColors.success, size: 13),
            const SizedBox(width: 3),
            const Text(
              'Quán Đối Tác',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderItemsList extends StatelessWidget {
  const _OrderItemsList({required this.items});

  final List<OrderItem> items;

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

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final state = ShopeeFoodScope.of(context);

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
                item.dish.image,
                fit: BoxFit.cover,
                fallback: AppImageFallback(label: formatCurrency(item.dish.price)),
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
                        item.dish.name,
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
                    InkWell(
                      onTap: () => state.removeLine(item.dish.id),
                      borderRadius: BorderRadius.circular(999),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.muted,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.dish.description,
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
                        formatCurrency(item.dish.price),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                    ),
                    _QuantityStepper(item: item),
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
  const _QuantityStepper({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final state = ShopeeFoodScope.of(context);
    final restaurant = state.cartRestaurant;

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
            onTap: () => state.removeDish(item.dish.id),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 12,
            child: Text(
              '${item.quantity}',
              textAlign: TextAlign.center,
              style: const TextStyle(
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
            onTap: restaurant == null
                ? null
                : () => state.addDish(restaurant, item.dish),
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
  const _VoucherCard({required this.discount});

  final int discount;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discount > 0;

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Flexible(
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
                      const SizedBox(width: 6),
                      if (hasDiscount) _DiscountBadge(discount: discount),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        hasDiscount
                            ? Icons.check_circle_outline_rounded
                            : Icons.info_outline_rounded,
                        color: hasDiscount ? AppColors.success : AppColors.muted,
                        size: 12,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          hasDiscount
                              ? 'Áp dụng thành công ưu đãi bạn mới'
                              : 'Thêm từ 50.000đ để dùng ưu đãi',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasDiscount
                                ? AppColors.success
                                : AppColors.muted,
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
  const _DiscountBadge({required this.discount});

  final int discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xffffdad3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '-${formatCurrency(discount)}',
        style: const TextStyle(
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
  const _BillSummaryCard({required this.state});

  final ShopeeFoodState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chi tiết thanh toán',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.38,
              ),
            ),
            const SizedBox(height: 10),
            _BillRow(
              label: 'Tạm tính (${state.cartItemCount} món)',
              value: formatCurrency(state.subtotal),
            ),
            const SizedBox(height: 8),
            _BillRow(
              label: 'Phí giao hàng (${state.cartRestaurant?.distanceLabel ?? '0 km'})',
              value: formatCurrency(state.deliveryFee),
              icon: Icons.info_outline_rounded,
            ),
            const SizedBox(height: 8),
            _BillRow(
              label: 'Giảm giá voucher',
              value: '-${formatCurrency(state.voucherDiscount)}',
              highlight: true,
            ),
            const SizedBox(height: 8),
            _BillRow(label: 'Phí dịch vụ', value: formatCurrency(state.serviceFee)),
            const SizedBox(height: 10),
            _TotalPanel(total: state.total),
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
  const _TotalPanel({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return _SoftPanel(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Expanded(
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
            formatCurrency(total),
            style: const TextStyle(
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
  const _CheckoutBottomBar({required this.state, required this.onOrder});

  final ShopeeFoodState state;
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Tổng thanh toán',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            formatCurrency(state.total),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                          Text(
                            'Tiết kiệm ${formatCurrency(state.voucherDiscount)}',
                            style: const TextStyle(
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
                        onPressed: state.cartItemCount == 0 ? null : onOrder,
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

class _EmptyCartCard extends StatelessWidget {
  const _EmptyCartCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.primary,
              size: 36,
            ),
            SizedBox(height: 8),
            Text(
              'Giỏ hàng đang trống',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Quay lại quán ăn để thêm món bạn thích.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
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
                    _showCheckoutAction(context, 'Đã đổi địa chỉ giao hàng');
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
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
