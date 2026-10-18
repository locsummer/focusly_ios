# Focusly: Screen Time (iOS)

Ứng dụng quản lý thời gian sử dụng thiết bị và tập trung cho nền tảng iOS, được xây dựng hoàn toàn bằng **Swift & SwiftUI** sử dụng hệ sinh thái **Apple Screen Time API** (`FamilyControls`, `ManagedSettings`, `DeviceActivity`).

## 1. Tính năng cốt lõi
1. **Screen Time Tracking**: Giám sát thời gian dùng máy qua `DeviceActivityReportExtension` bảo mật theo tiêu chuẩn Apple.
2. **App Blocking & Scheduling**: Chặn ứng dụng gây xao nhãng theo khung giờ cố định bằng `DeviceActivitySchedule` và `ManagedSettingsStore`.
3. **App Usage Limits**: Đặt hạn mức số phút tối đa cho từng app/danh mục (`DeviceActivityEvent` threshold).
4. **Focus Time / Pomodoro Timer**: Bộ đếm giờ tập trung (Pomodoro, Short Break, Deep Work) kết hợp chế độ Strict Mode tự động khóa app gây xao nhãng.
5. **Daily Insights & Reports**: Thống kê mức độ tập trung, số lần nhấc máy và phân loại ứng dụng.
6. **Smart Reminders**: Nhắc nhở cảnh báo 5 phút trước khi đạt hạn mức.

## 2. Kiến trúc & Frameworks
- **Frameworks Apple**:
  - `FamilyControls`: Cấp quyền truy cập Screen Time (`AuthorizationCenter.shared.requestAuthorization(for: .individual)`).
  - `ManagedSettings`: Khóa/mở khóa ứng dụng (`store.shield.applications`).
  - `ManagedSettingsUI`: Tùy biến giao diện màn hình khóa (`ShieldConfigurationExtension`).
  - `DeviceActivity`: Lập lịch giám sát chạy ngầm (`DeviceActivityMonitorExtension`).
  - `DeviceActivityReport`: Render biểu đồ và báo cáo Screen Time.
- **App Group**: `group.com.focusly.app` dùng để chia sẻ cấu hình giữa ứng dụng chính và các extension.

## 3. Cấu trúc thư mục
```
focusly_ios/
├── Focusly.xcodeproj/
├── Focusly/
│   ├── App/
│   │   └── FocuslyApp.swift
│   ├── Core/
│   │   ├── Constants/AppConstants.swift
│   │   ├── ScreenTime/ (ScreenTimeManager, ShieldManager, DeviceActivityManager)
│   │   └── Storage/UserPreferences.swift
│   ├── Models/ (AppLimit, BlockSchedule, FocusSession, DailyStats)
│   ├── ViewModels/ (DashboardViewModel, AppLimitsViewModel, FocusTimerViewModel, StatisticsViewModel)
│   ├── Views/ (Dashboard, Blocking, Focus, Statistics, Settings)
│   ├── Focusly.entitlements
│   └── Info.plist
├── FocuslyDeviceActivityMonitor/
├── FocuslyShieldConfiguration/
├── FocuslyShieldAction/
└── FocuslyDeviceActivityReport/
```

## 4. Hướng dẫn chạy trên Xcode
1. Mở `Focusly.xcodeproj` bằng **Xcode 15+** trên macOS.
2. Chọn Team của bạn trong mục **Signing & Capabilities**.
3. Bật Capability **Family Controls** và **App Groups** (`group.com.focusly.app`).
4. Chạy ứng dụng trên thiết bị thật iOS 16.0+ (Screen Time API yêu cầu thiết bị thật để kích hoạt đầy đủ FamilyControls).
