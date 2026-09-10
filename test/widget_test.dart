import 'package:app_shopeefood/main.dart';
import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the ShopeeFood login screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('ShopeeFood'), findsWidgets);
    expect(find.text('Tài khoản'), findsWidgets);
    expect(find.text('Mật khẩu'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Trang chủ'), findsOneWidget);
    expect(find.text('Đơn hàng'), findsOneWidget);
    expect(find.text('Tài khoản'), findsWidgets);
  });

  testWidgets('uses the reusable ShopeeFood logo widget', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(ShopeeFoodLogo), findsWidgets);
  });

  testWidgets('navigates from login to home screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    await logInWithValidCredentials(tester);

    expect(find.text('Freeship Hôm Nay'), findsOneWidget);
    expect(find.text('Khám phá danh mục'), findsOneWidget);
    expect(find.text('Quán gần bạn'), findsOneWidget);
    expect(find.text('Cơm Tấm Phúc Lộc Thọ'), findsOneWidget);
  });

  testWidgets('stays on login screen when credentials are wrong', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField).at(0), 'abc');
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.text('Đăng nhập'));
    await tester.pump();

    expect(find.text('Sai tài khoản hoặc mật khẩu'), findsOneWidget);
    expect(find.text('Freeship Hôm Nay'), findsNothing);
    expect(find.text('Đăng nhập'), findsOneWidget);
  });

  testWidgets('opens the restaurant detail screen from a home card', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await logInWithValidCredentials(tester);
    await tester.tap(find.text('Cơm Tấm Phúc Lộc Thọ'));
    await tester.pumpAndSettle();

    expect(find.text('Chi Tiết Quán Ăn'), findsOneWidget);
    expect(
      find.text('Cơm Tấm Phúc Lộc Thọ - Chi nhánh Quận 5'),
      findsOneWidget,
    );
    expect(find.text('Món bán chạy nhất 🔥'), findsOneWidget);
    expect(find.text('Cơm tấm sườn bì chả'), findsOneWidget);
  });

  testWidgets('moves from restaurant detail to checkout and order tracking', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await logInWithValidCredentials(tester);
    await tester.tap(find.text('Cơm Tấm Phúc Lộc Thọ'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Xem giỏ hàng'));
    await tester.pumpAndSettle();

    expect(find.text('Địa chỉ nhận món'), findsOneWidget);
    expect(find.text('Phương thức thanh toán'), findsOneWidget);
    expect(find.text('Tổng thanh toán'), findsWidgets);
    expect(find.text('Đặt hàng'), findsOneWidget);

    await tester.tap(find.text('Đặt hàng'));
    await tester.pumpAndSettle();

    expect(find.text('Theo Dõi Đơn Hàng'), findsOneWidget);
    expect(find.text('#SPF-88231'), findsOneWidget);
    expect(find.text('Trạng thái giao hàng'), findsOneWidget);
    expect(find.text('Nguyễn Văn A'), findsOneWidget);
    expect(find.text('Quay về trang chủ'), findsOneWidget);
  });
}

Future<void> logInWithValidCredentials(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), '123');
  await tester.enterText(find.byType(TextField).at(1), '123');
  await tester.tap(find.text('Đăng nhập'));
  await tester.pumpAndSettle();
}
