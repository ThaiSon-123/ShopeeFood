import 'package:app_shopeefood/shared/shopee_food_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

String formatCurrency(int value) {
  final text = value.toString();
  final buffer = StringBuffer();

  for (var index = 0; index < text.length; index++) {
    final remaining = text.length - index;
    buffer.write(text[index]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }

  return '${buffer}đ';
}

class DeliveryAddress {
  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.address,
    required this.receiver,
    required this.phone,
  });

  final String id;
  final String label;
  final String address;
  final String receiver;
  final String phone;

  String get contactLine => '$receiver • $phone';
}

class MenuDish {
  const MenuDish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.hot = false,
  });

  final String id;
  final String name;
  final String description;
  final int price;
  final String image;
  final String category;
  final bool hot;
}

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.branch,
    required this.category,
    required this.image,
    required this.coverImage,
    required this.distanceKm,
    required this.etaMin,
    required this.etaMax,
    required this.rating,
    required this.reviewCount,
    required this.address,
    required this.tags,
    required this.menu,
    this.partner = false,
    this.selected = false,
  });

  final String id;
  final String name;
  final String branch;
  final String category;
  final String image;
  final String coverImage;
  final double distanceKm;
  final int etaMin;
  final int etaMax;
  final double rating;
  final int reviewCount;
  final String address;
  final List<String> tags;
  final List<MenuDish> menu;
  final bool partner;
  final bool selected;

  String get displayName => '$name - $branch';
  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} km';
  String get etaLabel => '$etaMin-$etaMax phút';
  String get ratingLabel => rating.toStringAsFixed(1);
  bool get hasPromotion {
    return tags.any((tag) {
      final lower = tag.toLowerCase();
      return lower.contains('giảm') ||
          lower.contains('freeship') ||
          lower.contains('mua') ||
          lower.contains('voucher');
    });
  }
}

enum RestaurantFilter {
  nearby('Gần bạn'),
  topRated('Đánh giá cao'),
  promotion('Khuyến mãi');

  const RestaurantFilter(this.label);

  final String label;
}

enum OrderStatus {
  delivering('Đang giao'),
  delivered('Đã giao'),
  cancelled('Đã hủy');

  const OrderStatus(this.label);

  final String label;
}

class OrderItem {
  const OrderItem({required this.dish, required this.quantity});

  final MenuDish dish;
  final int quantity;

  int get total => dish.price * quantity;
}

class FoodOrder {
  const FoodOrder({
    required this.code,
    required this.restaurant,
    required this.items,
    required this.status,
    required this.address,
    required this.createdAt,
    required this.total,
    this.statusNote,
  });

  final String code;
  final Restaurant restaurant;
  final List<OrderItem> items;
  final OrderStatus status;
  final DeliveryAddress address;
  final String createdAt;
  final int total;
  final String? statusNote;

  int get itemCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);
}

class ShopeeFoodState extends ChangeNotifier {
  ShopeeFoodState()
    : _selectedAddress = demoAddresses.first,
      _orders = List<FoodOrder>.from(demoOrders);

  DeliveryAddress _selectedAddress;
  Restaurant? _cartRestaurant;
  final Map<String, int> _cartQuantities = {};
  final List<FoodOrder> _orders;

  DeliveryAddress get selectedAddress => _selectedAddress;
  Restaurant? get cartRestaurant => _cartRestaurant;
  List<FoodOrder> get orders => List.unmodifiable(_orders);

  List<OrderItem> get cartItems {
    final restaurant = _cartRestaurant;
    if (restaurant == null) {
      return const [];
    }

    return restaurant.menu
        .where((dish) => (_cartQuantities[dish.id] ?? 0) > 0)
        .map((dish) => OrderItem(dish: dish, quantity: _cartQuantities[dish.id]!))
        .toList();
  }

  int get cartItemCount =>
      _cartQuantities.values.fold<int>(0, (sum, quantity) => sum + quantity);

  int get subtotal => cartItems.fold<int>(0, (sum, item) => sum + item.total);
  int get deliveryFee =>
      _cartRestaurant == null ? 0 : 12000 + (_cartRestaurant!.distanceKm * 3500).round();
  int get serviceFee => cartItemCount == 0 ? 0 : 3000;
  int get voucherDiscount => subtotal >= 50000 ? 20000 : 0;
  int get total => subtotal + deliveryFee + serviceFee - voucherDiscount;

  String quantityFor(String dishId) => (_cartQuantities[dishId] ?? 0).toString();
  int quantityValueFor(String dishId) => _cartQuantities[dishId] ?? 0;

  void selectAddress(DeliveryAddress address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void addDish(Restaurant restaurant, MenuDish dish) {
    if (_cartRestaurant?.id != restaurant.id) {
      _cartRestaurant = restaurant;
      _cartQuantities.clear();
    }

    _cartQuantities[dish.id] = (_cartQuantities[dish.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeDish(String dishId) {
    final current = _cartQuantities[dishId] ?? 0;
    if (current <= 1) {
      _cartQuantities.remove(dishId);
    } else {
      _cartQuantities[dishId] = current - 1;
    }

    if (_cartQuantities.isEmpty) {
      _cartRestaurant = null;
    }

    notifyListeners();
  }

  void removeLine(String dishId) {
    _cartQuantities.remove(dishId);
    if (_cartQuantities.isEmpty) {
      _cartRestaurant = null;
    }
    notifyListeners();
  }

  void ensureCartHasDemoItems(Restaurant restaurant) {
    if (cartItemCount > 0 && _cartRestaurant?.id == restaurant.id) {
      return;
    }

    _cartRestaurant = restaurant;
    _cartQuantities.clear();
    for (final dish in restaurant.menu.take(2)) {
      _cartQuantities[dish.id] = 1;
    }
    notifyListeners();
  }

  FoodOrder placeOrder() {
    final restaurant = _cartRestaurant ?? demoRestaurants.first;
    final items = cartItems.isEmpty
        ? restaurant.menu.take(2).map((dish) => OrderItem(dish: dish, quantity: 1)).toList()
        : cartItems;
    final order = FoodOrder(
      code: '#SPF-88${240 + _orders.length}',
      restaurant: restaurant,
      items: items,
      status: OrderStatus.delivering,
      address: _selectedAddress,
      createdAt: 'Hôm nay, 11:32',
      total: total == 0
          ? items.fold<int>(0, (sum, item) => sum + item.total) + 14000
          : total,
      statusNote: 'Tài xế đang đến lấy món tại quán',
    );

    _orders.insert(0, order);
    notifyListeners();
    return order;
  }
}

class ShopeeFoodScope extends InheritedNotifier<ShopeeFoodState> {
  const ShopeeFoodScope({
    super.key,
    required ShopeeFoodState appState,
    required super.child,
  }) : super(notifier: appState);

  static ShopeeFoodState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ShopeeFoodScope>();
    assert(scope != null, 'ShopeeFoodScope not found in widget tree');
    return scope!.notifier!;
  }
}

const demoAddresses = [
  DeliveryAddress(
    id: 'home',
    label: 'Nhà',
    address: '123 Nguyễn Văn Cừ, P.4, Q.5',
    receiver: 'Nguyễn Thu Hà',
    phone: '0901 234 567',
  ),
  DeliveryAddress(
    id: 'office',
    label: 'Công ty',
    address: '88 Điện Biên Phủ, P.17, Q.Bình Thạnh',
    receiver: 'Võ Thái Sơn',
    phone: '0901 234 567',
  ),
  DeliveryAddress(
    id: 'friend',
    label: 'Bạn bè',
    address: '15 Lê Văn Sỹ, P.13, Q.3',
    receiver: 'Minh Anh',
    phone: '0918 456 789',
  ),
];

final demoRestaurants = <Restaurant>[
  Restaurant(
    id: 'com-tam-phuc-loc-tho',
    name: 'Cơm Tấm Phúc Lộc Thọ',
    branch: 'Chi nhánh Quận 5',
    category: 'Cơm',
    image: AppAssets.restaurantRice,
    coverImage: AppAssets.promoDish,
    distanceKm: 1.2,
    etaMin: 20,
    etaMax: 25,
    rating: 4.8,
    reviewCount: 724,
    address: '123 Nguyễn Văn Cừ, Phường 4, Quận 5, TP.HCM',
    partner: true,
    selected: true,
    tags: ['Freeship Xtra', 'Giảm 20k'],
    menu: [
      MenuDish(
        id: 'com-tam-suon-bi-cha',
        name: 'Cơm tấm sườn bì chả',
        description: 'Sườn nướng đậm đà, chả trứng béo ngậy, bì giòn thơm.',
        price: 45000,
        image: AppAssets.restaurantRice,
        category: 'Cơm',
        hot: true,
      ),
      MenuDish(
        id: 'com-suon-trung-op-la',
        name: 'Cơm sườn trứng ốp la',
        description: 'Sườn cốt lết ướp mật ong nướng than hồng, trứng lòng đào.',
        price: 50000,
        image: AppAssets.promoDish,
        category: 'Cơm',
      ),
      MenuDish(
        id: 'canh-rong-bien-thit-bam',
        name: 'Canh rong biển thịt bằm',
        description: 'Canh ngọt thanh mát, rong biển Hàn Quốc, thịt bằm tươi.',
        price: 20000,
        image: AppAssets.restaurantNoodles,
        category: 'Canh',
      ),
      MenuDish(
        id: 'tra-dao-cam-sa',
        name: 'Trà đào cam sả',
        description: 'Vị chua ngọt thanh mát giải nhiệt, miếng đào giòn.',
        price: 25000,
        image: AppAssets.categoryDrink,
        category: 'Đồ uống',
      ),
    ],
  ),
  Restaurant(
    id: 'tocotoco-nguyen-trai',
    name: 'Trà Sữa Tocotoco - Nguyễn Trãi',
    branch: 'Chi nhánh Quận 5',
    category: 'Trà sữa',
    image: AppAssets.restaurantTea,
    coverImage: AppAssets.restaurantTea,
    distanceKm: 0.8,
    etaMin: 15,
    etaMax: 20,
    rating: 4.7,
    reviewCount: 518,
    address: '215 Nguyễn Trãi, Phường 2, Quận 5, TP.HCM',
    partner: true,
    tags: ['Freeship', 'Mua 1 tặng 1'],
    menu: [
      MenuDish(
        id: 'milk-tea-brown-sugar',
        name: 'Trà sữa trân châu đường đen',
        description: 'Sữa tươi béo nhẹ, trân châu mềm và kem cheese mặn.',
        price: 32000,
        image: AppAssets.restaurantTea,
        category: 'Bán chạy',
        hot: true,
      ),
      MenuDish(
        id: 'matcha-cheese',
        name: 'Matcha kem cheese',
        description: 'Matcha thơm dịu, lớp kem cheese mặn béo vừa miệng.',
        price: 35000,
        image: AppAssets.home03,
        category: 'Trà sữa',
      ),
      MenuDish(
        id: 'oolong-vai',
        name: 'Trà ô long vải',
        description: 'Ô long rang thơm, vải ngọt thanh và thạch giòn.',
        price: 30000,
        image: AppAssets.categoryDrink,
        category: 'Trà trái cây',
      ),
    ],
  ),
  Restaurant(
    id: 'bun-bo-hue-an-nam',
    name: 'Bún Bò Huế An Nam',
    branch: 'Bếp Huế Quận 10',
    category: 'Bún / Phở',
    image: AppAssets.restaurantNoodles,
    coverImage: AppAssets.restaurantNoodles,
    distanceKm: 2.1,
    etaMin: 25,
    etaMax: 30,
    rating: 4.9,
    reviewCount: 934,
    address: '42 Thành Thái, Phường 12, Quận 10, TP.HCM',
    tags: ['Giảm 30k đơn 100k', 'Chuẩn vị Huế'],
    menu: [
      MenuDish(
        id: 'bun-bo-hue-dac-biet',
        name: 'Bún bò Huế đặc biệt',
        description: 'Tô lớn nhiều thịt, chả cua, sa tế thơm cay vừa miệng.',
        price: 55000,
        image: AppAssets.restaurantNoodles,
        category: 'Bán chạy',
        hot: true,
      ),
      MenuDish(
        id: 'bun-bo-tai-nam',
        name: 'Bún bò tái nạm',
        description: 'Thịt bò mềm, nước dùng đậm vị sả và ruốc Huế.',
        price: 48000,
        image: AppAssets.home06,
        category: 'Bún / Phở',
      ),
    ],
  ),
  Restaurant(
    id: 'ga-ran-gion-cay',
    name: 'Gà Rán Giòn Cay - Lê Hồng Phong',
    branch: 'Chi nhánh Quận 10',
    category: 'Gà rán',
    image: AppAssets.categoryChicken,
    coverImage: AppAssets.home01,
    distanceKm: 1.6,
    etaMin: 18,
    etaMax: 22,
    rating: 4.6,
    reviewCount: 281,
    address: '190 Lê Hồng Phong, Phường 4, Quận 10, TP.HCM',
    tags: ['Combo tiết kiệm', 'Gà cay'],
    menu: [
      MenuDish(
        id: 'ga-ran-sot-cay',
        name: 'Gà rán sốt cay',
        description: 'Miếng gà giòn phủ sốt cay ngọt, ăn kèm salad bắp cải.',
        price: 39000,
        image: AppAssets.home01,
        category: 'Gà rán',
        hot: true,
      ),
      MenuDish(
        id: 'combo-ga-khoai',
        name: 'Combo gà khoai tây',
        description: 'Hai miếng gà giòn, khoai tây lắc phô mai và nước ngọt.',
        price: 69000,
        image: AppAssets.categoryChicken,
        category: 'Combo',
      ),
    ],
  ),
  Restaurant(
    id: 'nuoc-ep-cam-tuoi-24h',
    name: 'Nước Ép Cam Tươi 24H',
    branch: 'Quầy Nguyễn Tri Phương',
    category: 'Đồ uống',
    image: AppAssets.categoryDrink,
    coverImage: AppAssets.categoryDrink,
    distanceKm: 0.5,
    etaMin: 10,
    etaMax: 15,
    rating: 4.8,
    reviewCount: 402,
    address: '67 Nguyễn Tri Phương, Phường 7, Quận 5, TP.HCM',
    tags: ['Mua 2 giảm 15%', 'Tươi mỗi ngày'],
    menu: [
      MenuDish(
        id: 'nuoc-cam-ep',
        name: 'Nước cam ép nguyên chất',
        description: 'Cam tươi ép sau khi đặt, không pha hương liệu.',
        price: 28000,
        image: AppAssets.categoryDrink,
        category: 'Đồ uống',
        hot: true,
      ),
      MenuDish(
        id: 'sinh-to-bo',
        name: 'Sinh tố bơ',
        description: 'Bơ sáp xay mịn, có thể chọn ít đường.',
        price: 32000,
        image: AppAssets.home02,
        category: 'Sinh tố',
      ),
    ],
  ),
  Restaurant(
    id: 'com-ga-ut-map',
    name: 'Cơm Gà Xối Mỡ Út Mập',
    branch: 'Bếp trưa Quận 3',
    category: 'Cơm',
    image: AppAssets.home12,
    coverImage: AppAssets.home12,
    distanceKm: 1.9,
    etaMin: 22,
    etaMax: 28,
    rating: 4.7,
    reviewCount: 367,
    address: '31 Cao Thắng, Phường 3, Quận 3, TP.HCM',
    tags: ['Cơm trưa', 'Giảm 15k'],
    menu: [
      MenuDish(
        id: 'com-ga-xoi-mo',
        name: 'Cơm gà xối mỡ',
        description: 'Đùi gà da giòn, cơm chiên tỏi và nước mắm chua ngọt.',
        price: 48000,
        image: AppAssets.home12,
        category: 'Cơm',
        hot: true,
      ),
    ],
  ),
  Restaurant(
    id: 'tra-sua-nha-lam',
    name: 'Trà Sữa Nhà Làm - Matcha & Kem Cheese',
    branch: 'Bếp Nguyễn Đình Chiểu',
    category: 'Trà sữa',
    image: AppAssets.restaurantTea,
    coverImage: AppAssets.restaurantTea,
    distanceKm: 1.1,
    etaMin: 15,
    etaMax: 20,
    rating: 4.8,
    reviewCount: 245,
    address: '74 Nguyễn Đình Chiểu, Quận 3, TP.HCM',
    tags: ['Best seller', 'Topping miễn phí'],
    menu: [
      MenuDish(
        id: 'tra-sua-kem-cheese',
        name: 'Trà sữa kem cheese',
        description: 'Trà đen thơm, kem cheese mặn béo, topping tự chọn.',
        price: 34000,
        image: AppAssets.restaurantTea,
        category: 'Trà sữa',
      ),
    ],
  ),
  Restaurant(
    id: 'pho-bo-gia-truyen',
    name: 'Phở Bò Tái Nạm Gia Truyền',
    branch: 'Bếp Phạm Văn Hai',
    category: 'Bún / Phở',
    image: AppAssets.restaurantNoodles,
    coverImage: AppAssets.home06,
    distanceKm: 2.4,
    etaMin: 25,
    etaMax: 30,
    rating: 4.9,
    reviewCount: 681,
    address: '102 Phạm Văn Hai, Quận Tân Bình, TP.HCM',
    tags: ['Nước dùng 12h', 'Freeship'],
    menu: [
      MenuDish(
        id: 'pho-bo-tai-nam',
        name: 'Phở bò tái nạm',
        description: 'Nước dùng ninh xương 12 giờ, bò tái mềm và nạm thơm.',
        price: 52000,
        image: AppAssets.restaurantNoodles,
        category: 'Bún / Phở',
        hot: true,
      ),
    ],
  ),
  Restaurant(
    id: 'ga-sot-mam-toi',
    name: 'Gà Sốt Mắm Tỏi - Cơm Văn Phòng',
    branch: 'Bếp Quận 5',
    category: 'Gà rán',
    image: AppAssets.home01,
    coverImage: AppAssets.home01,
    distanceKm: 1.4,
    etaMin: 18,
    etaMax: 24,
    rating: 4.7,
    reviewCount: 316,
    address: '9 An Dương Vương, Quận 5, TP.HCM',
    tags: ['Sốt mắm tỏi', 'Combo 2 người'],
    menu: [
      MenuDish(
        id: 'com-ga-mam-toi',
        name: 'Cơm gà sốt mắm tỏi',
        description: 'Gà giòn áo sốt mắm tỏi, cơm trắng và dưa leo.',
        price: 46000,
        image: AppAssets.home01,
        category: 'Cơm',
      ),
    ],
  ),
  Restaurant(
    id: 'sinh-to-co-ba',
    name: 'Sinh Tố Bơ Sầu Riêng Cô Ba',
    branch: 'Quầy Quận 5',
    category: 'Đồ uống',
    image: AppAssets.home02,
    coverImage: AppAssets.home02,
    distanceKm: 0.9,
    etaMin: 12,
    etaMax: 18,
    rating: 4.6,
    reviewCount: 208,
    address: '6 Trần Bình Trọng, Quận 5, TP.HCM',
    tags: ['Mát lạnh', 'Ít đường'],
    menu: [
      MenuDish(
        id: 'sinh-to-bo-sau-rieng',
        name: 'Sinh tố bơ sầu riêng',
        description: 'Bơ xay mịn cùng sầu riêng thơm béo, chọn mức đường.',
        price: 35000,
        image: AppAssets.home02,
        category: 'Sinh tố',
      ),
    ],
  ),
];

final demoOrders = <FoodOrder>[
  FoodOrder(
    code: '#SPF-88231',
    restaurant: demoRestaurants[0],
    items: [
      OrderItem(dish: demoRestaurants[0].menu[0], quantity: 1),
      OrderItem(dish: demoRestaurants[0].menu[1], quantity: 1),
    ],
    status: OrderStatus.delivering,
    address: demoAddresses[0],
    createdAt: 'Hôm nay, 11:15',
    total: 94000,
    statusNote: 'Tài xế đang giao, còn khoảng 8 phút',
  ),
  FoodOrder(
    code: '#SPF-88225',
    restaurant: demoRestaurants[2],
    items: [OrderItem(dish: demoRestaurants[2].menu[0], quantity: 2)],
    status: OrderStatus.delivered,
    address: demoAddresses[1],
    createdAt: 'Hôm qua, 18:42',
    total: 103000,
    statusNote: 'Đơn đã giao thành công',
  ),
  FoodOrder(
    code: '#SPF-88210',
    restaurant: demoRestaurants[6],
    items: [OrderItem(dish: demoRestaurants[6].menu[0], quantity: 1)],
    status: OrderStatus.cancelled,
    address: demoAddresses[0],
    createdAt: '08/09/2026, 12:20',
    total: 34000,
    statusNote: 'Khách hủy trước khi quán xác nhận',
  ),
];
