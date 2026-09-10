# Kế Hoạch Bài Tập Flutter Navigator - ShopeeFood

## 1. Tên Đề Tài

Ứng dụng mô phỏng giao diện ShopeeFood bằng Flutter.

Mục tiêu chính của bài làm là hiểu và sử dụng thành thạo `Navigator` trong Flutter thông qua các nút điều hướng giữa nhiều màn hình. Ứng dụng chỉ mô phỏng luồng đặt món cơ bản, sử dụng dữ liệu mẫu trong code, không cần dùng SQL hoặc cơ sở dữ liệu.

## 2. Số Lượng Màn Hình Dự Kiến

Dự kiến xây dựng 5 màn hình để thể hiện rõ các kiểu điều hướng:

1. Màn hình chào / đăng nhập
2. Màn hình trang chủ
3. Màn hình chi tiết quán ăn
4. Màn hình giỏ hàng / thanh toán
5. Màn hình theo dõi đơn hàng và tài khoản

Số lượng tối thiểu theo yêu cầu đề bài là 2 màn hình, nhưng ứng dụng làm 5 màn hình để thực hành nhiều trường hợp dùng `Navigator`.

## 3. Chức Năng Từng Màn Hình

### 3.1. Màn Hình Chào / Đăng Nhập

Chức năng:

- Hiển thị logo hoặc tên ứng dụng ShopeeFood.
- Có nút "Bắt đầu" hoặc "Đăng nhập".
- Có ô nhập tài khoản và mật khẩu.
- Tài khoản mẫu: `123`.
- Mật khẩu mẫu: `123`.
- Nếu nhập đúng tài khoản và mật khẩu, bấm nút sẽ chuyển sang màn hình trang chủ.
- Nếu nhập sai, ứng dụng hiển thị thông báo "Sai tài khoản hoặc mật khẩu" và không chuyển màn hình.

Điều hướng:

- Từ màn hình chào sang màn hình trang chủ bằng `Navigator.pushReplacement`.
- Mục đích: người dùng không quay lại màn hình chào khi bấm nút back.

### 3.2. Màn Hình Trang Chủ

Chức năng:

- Hiển thị thanh tìm kiếm món ăn hoặc quán ăn.
- Hiển thị địa chỉ giao hàng hiện tại.
- Hiển thị danh mục món ăn: Cơm, Trà sữa, Bún/Phở, Gà rán, Đồ uống.
- Hiển thị danh sách quán ăn nổi bật.
- Mỗi quán ăn có hình ảnh, tên quán, đánh giá, khoảng cách và thời gian giao hàng.
- Khi bấm vào một quán ăn, ứng dụng chuyển sang màn hình chi tiết quán ăn.
- Có thanh điều hướng dưới cùng gồm: Trang chủ, Đơn hàng, Tài khoản.

Điều hướng:

- Từ trang chủ sang chi tiết quán ăn bằng `Navigator.push`.
- Nút "Đơn hàng" hoặc tab đơn hàng có thể chuyển sang màn hình theo dõi đơn hàng bằng `Navigator.push`.
- Nút "Tài khoản" chuyển sang màn hình tài khoản bằng `Navigator.push`.

### 3.3. Màn Hình Chi Tiết Quán Ăn

Chức năng:

- Hiển thị ảnh bìa quán ăn, tên quán, đánh giá, địa chỉ, thời gian giao hàng.
- Hiển thị danh sách món ăn của quán.
- Mỗi món ăn có tên, giá, mô tả ngắn và nút thêm vào giỏ hàng.
- Cho phép tăng/giảm số lượng ở mức giao diện hoặc biến trạng thái đơn giản trong màn hình.
- Có nút xem giỏ hàng ở cuối màn hình.

Điều hướng:

- Bấm nút quay lại để về trang chủ bằng `Navigator.pop`.
- Bấm nút giỏ hàng để sang màn hình giỏ hàng / thanh toán.

### 3.4. Màn Hình Giỏ Hàng / Thanh Toán

Chức năng:

- Hiển thị một vài món mẫu đã chọn.
- Cho phép tăng/giảm số lượng ở mức mô phỏng nếu có thời gian.
- Tính tổng tiền đơn giản bằng dữ liệu mẫu hoặc biến trong code.
- Hiển thị địa chỉ giao hàng.
- Có lựa chọn phương thức thanh toán: tiền mặt hoặc ví điện tử.
- Có nút "Đặt hàng".

Điều hướng:

- Bấm nút quay lại để trở về chi tiết quán bằng `Navigator.pop`.
- Sau khi bấm "Đặt hàng", ứng dụng chuyển sang màn hình theo dõi đơn hàng bằng `Navigator.pushReplacement` hoặc `Navigator.push`.

### 3.5. Màn Hình Theo Dõi Đơn Hàng Và Tài Khoản

Chức năng:

- Hiển thị trạng thái đơn hàng: Đã nhận đơn, Đang chuẩn bị, Đang giao, Hoàn thành.
- Hiển thị thông tin quán ăn, món đã đặt và tổng tiền.
- Hiển thị thông tin tài xế giao hàng giả lập.
- Có nút quay về trang chủ để tiếp tục đặt món.
- Màn hình tài khoản hiển thị avatar, tên người dùng `Võ Thái Sơn`, mã sinh viên `2324801030030` và một số mục tài khoản mẫu.

Điều hướng:

- Từ theo dõi đơn hàng quay về trang chủ bằng `Navigator.pushAndRemoveUntil`.
- Mục đích: xóa các màn hình cũ khỏi stack và đưa người dùng về trang chủ.

## 4. Luồng Điều Hướng Tổng Quát

```text
Màn hình chào / đăng nhập
        |
        v
Trang chủ
        |
        v
Chi tiết quán ăn
        |
        v
Giỏ hàng / thanh toán
        |
        v
Theo dõi đơn hàng
        |
        v
Trang chủ
```

## 5. Các Thao Tác Nút Bấm Và Điều Hướng

Phần này mô tả rõ người dùng bấm vào đâu, sự kiện Flutter nào được gắn vào widget và màn hình sẽ chuyển như thế nào. Đây là trọng tâm để chứng minh bài làm sử dụng được `Navigator`.

| Màn hình hiện tại | Nút / thành phần được bấm | Sự kiện Flutter | Cách điều hướng | Kết quả mong đợi |
| --- | --- | --- | --- | --- |
| Đăng nhập | Nút `Đăng nhập` khi nhập đúng tài khoản `123` và mật khẩu `123` | `onPressed` của `ElevatedButton` | `Navigator.pushReplacement` | Chuyển sang màn hình `HomeScreen`, người dùng không quay lại màn hình đăng nhập bằng nút back. |
| Đăng nhập | Nút `Đăng nhập` khi nhập sai tài khoản hoặc mật khẩu | `onPressed` của `ElevatedButton` | Không gọi `Navigator` | Ở lại màn hình đăng nhập và hiển thị thông báo `Sai tài khoản hoặc mật khẩu`. |
| Trang chủ | Danh mục `Cơm`, `Trà sữa`, `Bún / Phở`, `Gà rán`, `Đồ uống` | `onTap` của `InkWell` | Không chuyển màn hình, dùng `setState` | Lọc danh sách quán/món theo danh mục được chọn và hiển thị phản hồi ngắn. |
| Trang chủ | Nút `Xem tất cả` trong phần danh mục | `onPressed` của `TextButton` | Không chuyển màn hình, dùng `setState` | Bỏ lọc danh mục và hiển thị lại toàn bộ danh sách món ăn/quán ăn. |
| Trang chủ | Chip `Gần nhất`, `Đánh giá cao`, `Khuyến mãi` | `onTap` của `InkWell` | Không chuyển màn hình | Hiển thị `SnackBar` mô phỏng thao tác lọc/sắp xếp. |
| Trang chủ | Card quán `Cơm Tấm Phúc Lộc Thọ` | `onTap` của `InkWell` | `Navigator.push` | Mở màn hình `RestaurantDetailScreen` để xem chi tiết quán ăn. |
| Chi tiết quán ăn | Nút mũi tên quay lại trên header | `onPressed` của `IconButton` | `Navigator.pop` | Quay lại màn hình trang chủ. |
| Chi tiết quán ăn | Nút `Xem giỏ hàng` | `onTap` của `InkWell` | `Navigator.push` | Mở màn hình `CartCheckoutScreen` để xem món đã chọn và thanh toán. |
| Giỏ hàng / thanh toán | Nút mũi tên quay lại trên header | `onPressed` của `IconButton` | `Navigator.pop` | Quay lại màn hình chi tiết quán ăn. |
| Giỏ hàng / thanh toán | Nút `Đặt hàng` | `onPressed` của `ElevatedButton` | `Navigator.push` | Mở màn hình `OrderTrackingScreen` để theo dõi trạng thái giao hàng. |
| Theo dõi đơn hàng | Nút mũi tên quay lại trên header | `onPressed` của `IconButton` | `Navigator.pop` | Quay lại màn hình giỏ hàng / thanh toán nếu người dùng muốn xem lại đơn. |
| Theo dõi đơn hàng | Nút `Quay về trang chủ` | `onPressed` của `ElevatedButton` | `Navigator.pushAndRemoveUntil` | Xóa các màn hình cũ khỏi stack và đưa người dùng về `HomeScreen`. |
| Bất kỳ màn chính | Tab `Tài khoản` ở thanh điều hướng dưới | `onTap` của item bottom nav | `Navigator.push` hoặc `Navigator.pushReplacement` | Mở màn hình `AccountScreen` hiển thị avatar, tên `Võ Thái Sơn` và mã `2324801030030`. |

Các nút mô phỏng không cần xử lý dữ liệu thật nhưng vẫn nên có phản hồi giao diện hoặc để trống an toàn:

| Màn hình | Nút mô phỏng | Vai trò trong giao diện | Cách xử lý dự kiến |
| --- | --- | --- | --- |
| Trang chủ | Nút thông báo, camera, bộ lọc | Làm giao diện giống ứng dụng đặt món thật | Hiển thị `SnackBar` để người dùng biết nút đã được bấm. |
| Chi tiết quán ăn | Nút `+` / `-` ở món ăn | Mô phỏng tăng giảm số lượng món | Nếu có thời gian, dùng `setState`; nếu không, giữ số lượng mẫu. |
| Giỏ hàng / thanh toán | Nút `+` / `-`, nút xóa món | Mô phỏng chỉnh sửa giỏ hàng | Có thể làm giao diện tĩnh hoặc nâng cấp bằng `setState`. |
| Giỏ hàng / thanh toán | Nút `Thay đổi` địa chỉ, `Đổi mã` voucher | Mô phỏng thao tác phụ khi thanh toán | Có thể mở rộng sau bằng dialog hoặc màn hình phụ, hiện tại không bắt buộc. |
| Theo dõi đơn hàng | Nút gọi tài xế, nhắn tin, sao chép mã đơn, chia sẻ | Mô phỏng thao tác phụ của đơn hàng | Có thể để trống hoặc hiển thị `SnackBar` nếu muốn có phản hồi. |

Luồng bấm nút chính khi chạy thử:

```text
Bấm Đăng nhập
  -> nếu tài khoản là 123 và mật khẩu là 123 thì vào Trang chủ
  -> nếu nhập sai thì ở lại màn hình đăng nhập

Bấm card Cơm Tấm Phúc Lộc Thọ
  -> vào Chi tiết quán ăn

Bấm Xem giỏ hàng
  -> vào Giỏ hàng / thanh toán

Bấm Đặt hàng
  -> vào Theo dõi đơn hàng

Bấm Quay về trang chủ
  -> trở về Trang chủ và xóa stack cũ
```

## 6. Dữ Liệu Dự Kiến Sử Dụng

Ứng dụng chỉ sử dụng dữ liệu mẫu khai báo trực tiếp trong code.

Ví dụ dữ liệu mẫu:

- Danh sách quán ăn: tên quán, ảnh, đánh giá, khoảng cách, thời gian giao hàng.
- Danh sách món ăn: tên món, giá, mô tả ngắn.
- Giỏ hàng: danh sách món đã chọn ở mức mô phỏng.
- Đơn hàng: trạng thái đơn hàng và tổng tiền mẫu.

Không sử dụng SQLite, không tạo bảng dữ liệu và không cần lưu dữ liệu lâu dài sau khi tắt ứng dụng.

## 7. Package Flutter Dự Kiến

Có thể làm bài chỉ với Flutter SDK mặc định. Nếu muốn giao diện đẹp hơn, có thể dùng thêm:

- `google_fonts`: cải thiện giao diện chữ.
- `cached_network_image` hoặc `Image.network`: hiển thị ảnh món ăn/quán ăn.

Không cần dùng:

- `sqflite`
- `path`
- Các package database khác

Nếu cần quản lý trạng thái đơn giản, có thể dùng `setState` là đủ cho phạm vi bài tập Navigator.

## 8. Màu Sắc Và Phong Cách Giao Diện

Phong cách giao diện sẽ dựa theo ShopeeFood:

- Màu chủ đạo: cam / đỏ cam.
- Nền: trắng hoặc xám rất nhạt.
- Nút chính: màu cam nổi bật.
- Card quán ăn: có ảnh, tên quán, rating, khoảng cách và thời gian giao hàng.
- Giao diện ưu tiên dễ nhìn, dễ thao tác trên điện thoại.

## 9. Yêu Cầu Cần Đạt Được

- Có tối thiểu 2 màn hình theo yêu cầu đề bài.
- Có nhiều nút điều hướng giữa các màn hình bằng Flutter `Navigator`.
- Sử dụng được các thao tác điều hướng cơ bản:
  - `Navigator.push`
  - `Navigator.pop`
  - `Navigator.pushReplacement`
  - `Navigator.pushAndRemoveUntil`
- Giao diện có chủ đề rõ ràng là ShopeeFood.
- Các chức năng đặt món chỉ cần mô phỏng để phục vụ việc điều hướng.
- Không yêu cầu đăng nhập thật, thanh toán thật hoặc lưu dữ liệu bằng SQL.

## 10. Thứ Tự Thực Hiện Dự Kiến

1. Tạo cấu trúc thư mục cho `screens`, `models`, `data` và `widgets`.
2. Tạo màn hình chào / đăng nhập.
3. Tạo màn hình trang chủ và danh sách quán ăn.
4. Tạo màn hình chi tiết quán ăn và danh sách món.
5. Tạo thao tác thêm món mẫu vào giỏ hàng bằng `setState`.
6. Tạo màn hình giỏ hàng / thanh toán.
7. Tạo màn hình theo dõi đơn hàng.
8. Thêm các nút điều hướng bằng `Navigator.push`, `Navigator.pop`, `Navigator.pushReplacement` và `Navigator.pushAndRemoveUntil`.
9. Kiểm tra lại toàn bộ luồng bấm nút từ màn hình chào đến trang chủ, chi tiết quán, giỏ hàng, theo dõi đơn hàng và quay về trang chủ.

## 11. Trọng Tâm Bài Học Navigator

Bài tập cần thể hiện rõ người học biết cách:

- Tạo nhiều màn hình Flutter riêng biệt.
- Gắn sự kiện `onPressed` hoặc `onTap` cho các nút/card.
- Chuyển từ màn hình này sang màn hình khác bằng `Navigator.push`.
- Quay lại màn hình trước bằng `Navigator.pop`.
- Thay thế màn hình hiện tại bằng `Navigator.pushReplacement`.
- Xóa stack cũ và quay về trang chủ bằng `Navigator.pushAndRemoveUntil`.
- Truyền dữ liệu đơn giản giữa các màn hình, ví dụ truyền thông tin quán ăn từ trang chủ sang màn hình chi tiết.
