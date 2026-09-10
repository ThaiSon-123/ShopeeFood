import 'dart:ui';

import 'package:app_shopeefood/data/shopee_food_data.dart';
import 'package:app_shopeefood/screens/account_screen.dart';
import 'package:app_shopeefood/screens/home_screen.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  OrderStatus _selectedStatus = OrderStatus.delivering;

  @override
  Widget build(BuildContext context) {
    final topSafeArea = MediaQuery.paddingOf(context).top;
    final state = ShopeeFoodScope.of(context);
    final orders = state.orders
        .where((order) => order.status == _selectedStatus)
        .toList();
    final selectedOrder = orders.isEmpty ? null : orders.first;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topSafeArea + 100, 0, 98),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StatusTabs(
                      selectedStatus: _selectedStatus,
                      onTap: (status) => setState(() {
                        _selectedStatus = status;
                      }),
                    ),
                    const SizedBox(height: 12),
                    if (selectedOrder == null)
                      _EmptyStatusCard(status: _selectedStatus)
                    else ...[
                      if (_selectedStatus == OrderStatus.delivering) ...[
                        _TrackingMap(order: selectedOrder),
                        const SizedBox(height: 12),
                        _OrderCodeRow(order: selectedOrder),
                        const SizedBox(height: 12),
                        _DeliveryStepperCard(order: selectedOrder),
                        const SizedBox(height: 12),
                        const _DriverCard(),
                        const SizedBox(height: 12),
                      ] else ...[
                        _OrderCodeRow(order: selectedOrder),
                        const SizedBox(height: 12),
                        _StatusSummaryCard(order: selectedOrder),
                        const SizedBox(height: 12),
                      ],
                      _OrdersList(orders: orders.skip(1).toList()),
                      const SizedBox(height: 12),
                      _CompactOrderSummary(order: selectedOrder),
                      const SizedBox(height: 20),
                      const _ReturnHomeButton(),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const Positioned(left: 0, right: 0, top: 0, child: _TrackingHeader()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ShopeeBottomNav(
              activeIndex: 1,
              onTap: (index) => _handleBottomNav(context, index),
            ),
          ),
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
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const AccountScreen()),
      );
    }
  }
}

class _TrackingHeader extends StatelessWidget {
  const _TrackingHeader();

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
                            'Theo Dõi Đơn Hàng',
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
                          onPressed: () => _showTrackingAction(
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

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({required this.selectedStatus, required this.onTap});

  final OrderStatus selectedStatus;
  final ValueChanged<OrderStatus> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final status in OrderStatus.values) ...[
            Expanded(
              child: _StatusChip(
                status: status,
                active: selectedStatus == status,
                onTap: () => onTap(status),
              ),
            ),
            if (status != OrderStatus.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.active,
    required this.onTap,
  });

  final OrderStatus status;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      OrderStatus.delivering => Icons.delivery_dining_rounded,
      OrderStatus.delivered => Icons.check_circle_outline_rounded,
      OrderStatus.cancelled => Icons.cancel_outlined,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: active ? Colors.white : AppColors.primary, size: 15),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                status.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingMap extends StatelessWidget {
  const _TrackingMap({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 288,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          Positioned(
            left: 40,
            top: 50,
            child: _MapMarker(
              label: order.restaurant.name,
              color: const Color(0xffa73a00),
              icon: Icons.storefront_rounded,
            ),
          ),
          Positioned(
            right: 36,
            top: 170,
            child: _MapMarker(
              label: order.address.address,
              color: const Color(0xff00873a),
              icon: Icons.home_rounded,
            ),
          ),
          const Positioned(left: 128, top: 86, child: _DriverMapMarker()),
          const Positioned(left: 16, right: 16, bottom: 12, child: _EtaPill()),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xffe9e7ed));

    canvas.drawCircle(
      Offset(size.width * 0.92, 20),
      78,
      Paint()..color = const Color(0xffd7e8f7).withValues(alpha: 0.75),
    );
    canvas.drawCircle(
      Offset(size.width * 0.16, size.height * 0.92),
      82,
      Paint()..color = const Color(0xffd8f0de).withValues(alpha: 0.85),
    );

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    for (final x in [size.width * 0.22, size.width * 0.55, size.width * 0.85]) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), road);
    }
    for (final y in [
      size.height * 0.24,
      size.height * 0.6,
      size.height * 0.83,
    ]) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), road);
    }

    final route = Paint()
      ..color = const Color(0xffd63c1e)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.17, size.height * 0.31)
      ..cubicTo(
        size.width * 0.2,
        size.height * 0.55,
        size.width * 0.44,
        size.height * 0.48,
        size.width * 0.51,
        size.height * 0.48,
      )
      ..cubicTo(
        size.width * 0.67,
        size.height * 0.48,
        size.width * 0.74,
        size.height * 0.58,
        size.width * 0.82,
        size.height * 0.65,
      );
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MapLabel(label: label),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
      ],
    );
  }
}

class _DriverMapMarker extends StatelessWidget {
  const _DriverMapMarker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xffd63c1e),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.delivery_dining_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Tài xế xế yêu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 118),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
      ),
    );
  }
}

class _EtaPill extends StatelessWidget {
  const _EtaPill();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            children: [
              _TintCircle(icon: Icons.timer_outlined),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dự kiến: 11:45 (còn 8 phút)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.38,
                  ),
                ),
              ),
              SizedBox(width: 8),
              _EtaBadge(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EtaBadge extends StatelessWidget {
  const _EtaBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xffffdbce),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Đúng giờ',
        style: TextStyle(
          color: Color(0xff370e00),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          height: 1.27,
        ),
      ),
    );
  }
}

class _OrderCodeRow extends StatelessWidget {
  const _OrderCodeRow({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'Mã đơn:',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              height: 1.38,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              order.code,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                height: 1.38,
              ),
            ),
          ),
          InkWell(
            onTap: () =>
                _showTrackingAction(context, 'Đã sao chép mã đơn ${order.code}'),
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.copy_rounded, color: Color(0xff8f7069), size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Sao chép',
                    style: TextStyle(
                      color: Color(0xff8f7069),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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

class _DeliveryStepperCard extends StatelessWidget {
  const _DeliveryStepperCard({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        height: 192,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Trạng thái giao hàng',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.33,
                      ),
                    ),
                  ),
                  _LiveBadge(),
                ],
              ),
            ),
            const Positioned(left: 8, right: 8, top: 48, child: _StepperBar()),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _DriverNotice(note: order.statusNote ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperBar extends StatelessWidget {
  const _StepperBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20,
          right: 20,
          top: 16,
          child: Container(height: 3, color: AppColors.divider),
        ),
        Positioned(
          left: 20,
          right: 78,
          top: 16,
          child: Container(height: 3, color: const Color(0xffd63c1e)),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StepNode(
              label: 'Đã nhận',
              icon: Icons.check_rounded,
              complete: true,
            ),
            _StepNode(
              label: 'Chuẩn bị',
              icon: Icons.check_rounded,
              complete: true,
            ),
            _StepNode(
              label: 'Đang giao',
              icon: Icons.delivery_dining_rounded,
              active: true,
            ),
            _StepNode(label: 'Hoàn thành', icon: Icons.check_rounded),
          ],
        ),
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.label,
    required this.icon,
    this.complete = false,
    this.active = false,
  });

  final String label;
  final IconData icon;
  final bool complete;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = complete
        ? AppColors.success
        : active
        ? const Color(0xffd63c1e)
        : AppColors.divider;
    final textColor = active
        ? AppColors.primary
        : complete
        ? AppColors.text
        : const Color(0xff8f7069);

    return SizedBox(
      width: 66,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              icon,
              color: active || complete ? Colors.white : const Color(0xff8f7069),
              size: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: active ? 11 : 10,
              fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xff71fe91).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 6, height: 6),
          ),
          SizedBox(width: 4),
          Text(
            'Trực tiếp',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverNotice extends StatelessWidget {
  const _DriverNotice({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffffdad3).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.near_me_outlined, color: AppColors.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              note.isEmpty
                  ? 'Tài xế đang giao món. Vui lòng để ý điện thoại khi shipper đến nhé!'
                  : note,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 13,
                height: 1.38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 52,
              height: 52,
              child: ClipOval(
                child: AppAssetImage(
                  AppAssets.profile,
                  fallback: AppImageFallback(icon: Icons.person_rounded),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Nguyễn Văn A',
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
                      SizedBox(width: 6),
                      Text(
                        '★ 4.9',
                        style: TextStyle(
                          color: Color(0xfff59e0b),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Honda Wave • 59-P1 889.92',
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
            _CircleIcon(
              icon: Icons.phone_rounded,
              size: 44,
              iconSize: 18,
              background: const Color(0xffffdbce),
              foreground: const Color(0xff370e00),
              onTap: () =>
                  _showTrackingAction(context, 'Đang gọi tài xế Nguyễn Văn A'),
            ),
            const SizedBox(width: 8),
            _CircleIcon(
              icon: Icons.chat_bubble_rounded,
              size: 44,
              iconSize: 18,
              background: AppColors.primary,
              foreground: Colors.white,
              onTap: () =>
                  _showTrackingAction(context, 'Đã mở tin nhắn với tài xế'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusSummaryCard extends StatelessWidget {
  const _StatusSummaryCard({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    final isCancelled = order.status == OrderStatus.cancelled;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _TintIcon(
              icon: isCancelled
                  ? Icons.cancel_outlined
                  : Icons.check_circle_outline_rounded,
              size: 40,
              iconSize: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.status.label,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order.statusNote ?? '',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
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

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});

  final List<FoodOrder> orders;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (final order in orders) ...[
            _OrderHistoryCard(order: order),
            if (order != orders.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  const _OrderHistoryCard({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 54,
              height: 54,
              child: AppAssetImage(
                order.restaurant.image,
                fit: BoxFit.cover,
                fallback: AppImageFallback(label: order.status.label),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.restaurant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      order.code,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${order.itemCount} món • ${order.createdAt}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        order.statusNote ?? order.status.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: order.status == OrderStatus.cancelled
                              ? AppColors.primary
                              : AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      formatCurrency(order.total),
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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

class _CompactOrderSummary extends StatelessWidget {
  const _CompactOrderSummary({required this.order});

  final FoodOrder order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const _TintIcon(
                  icon: Icons.restaurant_rounded,
                  size: 24,
                  iconSize: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.restaurant.name,
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
                Text(
                  '${order.itemCount} món',
                  style: const TextStyle(color: Color(0xff8f7069), fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (final item in order.items.take(3)) ...[
              _SummaryItem(
                label: '${item.quantity}× ${item.dish.name}',
                price: formatCurrency(item.total),
              ),
              const SizedBox(height: 6),
            ],
            const SizedBox(height: 6),
            _PaymentTotalRow(total: order.total),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.price});

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 13,
              height: 1.38,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          price,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.23,
          ),
        ),
      ],
    );
  }
}

class _PaymentTotalRow extends StatelessWidget {
  const _PaymentTotalRow({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Ví ShopeePay',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(
            'Tổng cộng: ',
            style: TextStyle(
              color: Color(0xff8f7069),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formatCurrency(total),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnHomeButton extends StatelessWidget {
  const _ReturnHomeButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home_outlined, size: 18),
              SizedBox(width: 8),
              Text(
                'Quay về trang chủ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStatusCard extends StatelessWidget {
  const _EmptyStatusCard({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _SurfaceCard(
        padding: const EdgeInsets.all(18),
        child: Text(
          'Chưa có đơn ${status.label.toLowerCase()}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child, required this.padding, this.height});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
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
      child: child,
    );
  }
}

class _TintIcon extends StatelessWidget {
  const _TintIcon({required this.icon, this.size = 32, this.iconSize = 18});

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xffffdad3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: AppColors.primary, size: iconSize),
    );
  }
}

class _TintCircle extends StatelessWidget {
  const _TintCircle({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xffffdad3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.primary, size: 18),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    required this.icon,
    required this.background,
    required this.foreground,
    this.size = 24,
    this.iconSize = 15,
    this.onTap,
  });

  final IconData icon;
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
        child: Icon(icon, color: foreground, size: iconSize),
      ),
    );
  }
}

void _showTrackingAction(BuildContext context, String message) {
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
