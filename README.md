<p align="center">
  <img src="assets/logo.png" alt="Calculator Logo" width="200" height="200">
</p>

# Calculator

A powerful and feature-rich calculator application built with Flutter, powered by the Microsoft Calculator engine (wincalc_engine).

## Features

### Calculator Modes
- **Standard Calculator**: Basic arithmetic operations with a clean, intuitive interface
- **Scientific Calculator**: Advanced mathematical functions with interactive flyout menus
  - Trigonometry flyout (sin, cos, tan, and their inverses)
  - Function flyout (log, ln, exp, power, root, etc.)
- **Programmer Calculator**: Binary, hexadecimal, octal, and decimal conversions
  - Bitwise operations with shift flyout
  - Bitwise logic with bitwise flyout
  - Bit flip keypad for binary manipulation

### Unit Converters
Comprehensive support for various unit conversions:
- Angle (Degrees, Radians, Gradians)
- Area
- Data (Bytes, KB, MB, GB, etc.)
- Energy
- Length
- Power
- Pressure
- Speed
- Temperature (with support for negative values)
- Time
- Volume
- Weight/Mass

### Additional Features
- **Memory Functions**: Store, recall, and clear memory values (MC, MR, M+, M-)
- **Date Calculation**: Calculate date differences and add/subtract dates
- **History Tracking**: View and reuse previous calculations with history list
- **Responsive Design**: Adaptive UI that works beautifully on all screen sizes
  - Tablet-optimized layout with landscape orientation support
  - Phone-focused portrait layout
  - Responsive sidebar and navigation
- **Internationalization**: Full support for English and Chinese languages
  - Automatic language detection
  - Language switching capability
  - Localized fonts using chinese_font_library
- **Window Management**: Desktop-ready with custom title bar and window controls
  - Custom title bar with minimize, maximize, close buttons
  - Minimum window size enforcement (340x560)
  - Window focus management
- **Theme Support**: Clean, modern design with consistent theming
  - Light and dark theme modes
  - System theme following
  - Consistent color system with app_colors.dart
- **Keyboard Support**: Full keyboard navigation and input support
- **Edge-to-Edge UI**: Immersive experience on mobile platforms
  - Transparent status bar on Android/iOS
  - Edge-to-edge display mode
  - Proper safe area handling
- **Accessibility**: Semantic labels and screen reader support

## Tech Stack

- **Framework**: Flutter 3.38.7 (Dart 3.10.7)
- **State Management**: Riverpod 3.1.0 with code generation
- **Routing**: go_router 17.0.1 with Shell architecture for unified navigation
- **Calculator Engine**: wincalc_engine 0.0.9 (Microsoft's Calculator Manager)
- **Platform Integration**: FFI for native code interop
- **Window Management**: window_manager 0.5.1 for desktop platforms
- **Persistence**: shared_preferences 2.5.4 for settings storage
- **Internationalization**: flutter_localizations, intl, chinese_font_library
- **Logging**: Comprehensive logging system with environment-based configuration
- **UI Layout**: flutter_layout_grid 2.0.8 for responsive grid layouts
- **Code Generation**: build_runner, riverpod_generator, go_router_builder

## Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Windows
- ✅ macOS
- ✅ Linux
- ❌ Web

## Key Highlights (Recent Refactor)

### Architecture Improvements
- **Feature-based organization**: Clear separation between calculator modes with dedicated feature modules
- **Enhanced service layer**: Granular services for history, input, layout, and calculator operations
- **Flyout architecture**: Interactive menus for scientific and programmer calculators
- **Responsive design**: Optimized layouts for phones and tablets with proper orientation handling

### New Features
- **Memory functions**: MC, MR, M+, M- operations for storing and recalling values
- **Programmer calculator enhancements**:
  - Binary formatter with bitwise display
  - Bit flip keypad for interactive binary manipulation
  - Shift and bitwise flyout menus
- **Scientific calculator enhancements**:
  - Function flyout (log, ln, exp, power, root, etc.)
  - Trigonometry flyout (sin, cos, tan, and their inverses)
  - Angle type support (degrees, radians, gradians)
- **Custom title bar**: Desktop platforms with custom window controls
- **Edge-to-edge UI**: Immersive mobile experience with transparent status bar

### Code Quality
- **Code generation**: Extensive use of build_runner for type-safe code
- **Extension methods**: Comprehensive barrel file for all extensions
- **Logging**: Environment-based logging configuration
- **Testing**: Improved test infrastructure and guidelines

## Getting Started

### Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK (compatible with Flutter version)
- For desktop platforms, refer to [Flutter desktop setup](https://flutter.dev/desktop)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/dongfengweixiao/calculator.git
cd calculator
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation (if needed):
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

4. Run the application:
```bash
# Default platform
flutter run

# For specific platforms
flutter run -d windows
flutter run -d macos
flutter run -d linux
flutter run -d android
flutter run -d ios
```

### Development Commands

```bash
# Code generation
flutter packages pub run build_runner build
flutter packages pub run build_runner watch

# Analysis & Linting
flutter analyze
dart format .

# Clean build
flutter clean
flutter pub get

# Testing
flutter test
flutter test --coverage
```

### Building for Release

#### Android
```bash
flutter build apk
# or
flutter build appbundle
```

#### iOS
```bash
flutter build ios
```

#### Windows
```bash
flutter build windows
```

#### macOS
```bash
flutter build macos
```

#### Linux
```bash
flutter build linux
```

#### Web
```bash
flutter build web
```

## Project Structure

```
lib/
├── app/                       # App-level configuration and providers
│   └── providers.dart       # Global application providers
├── core/                      # Core functionality and shared utilities
│   ├── config/               # Configuration files (converter configs, logger)
│   ├── domain/               # Domain entities and constants
│   │   ├── constants/        # App-wide constants (calculator commands, limits)
│   │   └── entities/         # Domain entities (history, modes, types)
│   ├── router/               # Navigation routing with go_router
│   │   ├── app_router.dart   # Router configuration
│   │   ├── app_router.g.dart # Generated router code
│   │   ├── route_observer.dart
│   │   └── nav_config.dart
│   ├── services/             # Business logic services
│   │   ├── history/          # History services (delete, format, recall)
│   │   ├── input/            # Input services (formatter, validator, mapper)
│   │   ├── layout/           # Layout services (responsive, button visibility)
│   │   ├── persistence/      # Data persistence service
│   │   ├── scientific/        # Scientific calculator services
│   │   │   ├── angle_service.dart
│   │   │   └── trig_mode_service.dart
│   │   └── calculator_service.dart  # Main calculator service
│   ├── shell/                # Shell architecture components
│   │   ├── app_shell.dart    # Main app shell with sidebar and header
│   │   ├── app_header.dart   # App header with navigation controls
│   │   ├── app_sidebar.dart  # Navigation sidebar
│   │   └── responsive_side_panel.dart
│   ├── theme/                # App theming and styling
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_font_sizes.dart
│   │   ├── app_dimensions.dart
│   │   └── app_icons.dart
│   ├── utils/                # Utility functions
│   │   ├── unit_icons.dart
│   │   └── unit_localization.dart
│   └── widgets/              # Reusable core widgets
│       ├── calc_button.dart
│       └── custom_title_bar.dart
├── features/                 # Feature-specific implementations
│   ├── calculator/           # Calculator main view
│   │   ├── calculator_provider.dart
│   │   ├── display_panel.dart
│   │   ├── navigation_drawer.dart
│   │   └── panel_state.dart
│   ├── calculators/          # Individual calculator pages
│   │   ├── standard_calculator_page.dart
│   │   ├── scientific_calculator_page.dart
│   │   ├── programmer_calculator_page.dart
│   │   └── date_calculation_page.dart
│   ├── converters/           # Unit converters (unified implementation)
│   │   └── unit_converter_page.dart
│   ├── date_calculation/     # Date calculation feature
│   │   └── date_calculation_body.dart
│   ├── history/              # History tracking feature
│   │   └── history_list_content.dart
│   ├── memory/               # Memory management feature
│   │   └── memory_list_content.dart
│   ├── programmer/           # Programmer calculator specific UI
│   │   ├── programmer_provider.dart
│   │   ├── bit_converter.dart
│   │   ├── binary_formatter.dart
│   │   ├── flyouts/          # Flyout menus
│   │   │   ├── shift_flyout.dart
│   │   │   └── bitwise_flyout.dart
│   │   ├── services/
│   │   │   └── programmer_button_service.dart
│   │   └── widgets/
│   │       └── bit_flip_keypad.dart
│   ├── scientific/           # Scientific calculator specific UI
│   │   ├── scientific_provider.dart
│   │   ├── scientific_widgets.dart
│   │   ├── flyouts/          # Flyout menus
│   │   │   ├── func_flyout.dart
│   │   │   ├── trig_flyout.dart
│   │   │   ├── button_state.dart
│   │   │   ├── menu_buttons.dart
│   │   │   └── flyout_container.dart
│   │   └── buttons/
│   └── settings/             # Application settings page
│       └── settings_page.dart
├── shared/                   # Shared widgets and utilities
│   ├── locale/               # Locale management
│   │   └── locale_provider.dart
│   ├── navigation/           # Navigation logic
│   │   ├── navigation_provider.dart
│   │   └── panel_provider.dart
│   ├── theme/                # Theme management
│   │   └── theme_provider.dart
│   └── widgets/              # Shared widgets
│       ├── unit_converter_body.dart
│       ├── converter_keypad.dart
│       └── converter_display_panel.dart
├── extensions/               # Extension methods barrel file
│   ├── build_context_x.dart
│   ├── double_x.dart
│   ├── num_x.dart
│   ├── string_x.dart
│   └── theme_data_x.dart
├── l10n/                     # Internationalization files
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   ├── app_localizations_zh.dart
│   └── l10n.dart
├── utils/                    # Utility functions
│   └── device_utils.dart
└── main.dart                # Application entry point
```

## Architecture

This application follows a clean architecture pattern with clear separation of concerns:

### Shell Architecture
The app uses a **Shell architecture** powered by `go_router` with `ShellRoute` pattern:
- **AppShell**: Provides a unified application shell with responsive side panel, header, and content area
- **AppHeader**: Consistent header with hamburger menu and history/memory toggle buttons
- **AppSidebar**: Navigation sidebar with responsive layout (hidden on small screens)
- **ResponsiveSidePanel**: Dynamic panel that adapts to screen size and device type
- **Type-safe Routing**: Uses go_router with code generation for declarative, type-safe navigation

### Layered Architecture
- **Domain Layer**: Business entities (`CalculatorMode`, `HistoryItem`, `TrigMode`, `AngleType`) and use cases
- **Service Layer**: Business logic and data processing
  - `CalculatorService`: Main interface to wincalc_engine
  - `HistoryService`: History management (delete, format, recall)
  - `InputService`: Input handling (formatter, validator, command mapping)
  - `LayoutService`: Responsive layout and button visibility
  - `AngleService`, `TrigModeService`: Scientific calculator state
- **Presentation Layer**: UI components and state management with Riverpod
  - Feature-based providers (`CalculatorProvider`, `ScientificProvider`, `ProgrammerProvider`)
  - Widget components organized by feature
- **Data Layer**: Persistence and external service integration
  - `PreferencesService`: Settings storage using shared_preferences

### Key Design Patterns
- **Feature-Based Architecture**: Each calculator mode is a self-contained feature
- **Flyout Pattern**: Interactive menus for scientific and programmer calculators
- **Generic Converter Pattern**: Single `UnitConverterPage` handles all converter types through configuration
- **Responsive Layout**: Adapts to different screen sizes with sidebar behavior and device-specific optimizations
- **Code Deduplication**: Centralized configuration and utilities minimize duplicate code
- **Provider Pattern**: Riverpod with code generation for type-safe state management
- **Extension Methods**: Barrel file exports all extensions (`build_context_x`, `double_x`, `num_x`, `string_x`, `theme_data_x`)

### Service Architecture
Services are organized by domain and functionality:
- **history/**: History tracking (`HistoryDeleter`, `HistoryFormatter`, `HistoryRecallService`)
- **input/**: Input processing (`InputFormatter`, `InputValidator`, `CommandMapper`)
- **layout/**: Layout management (`ResponsiveLayoutService`, `ButtonVisibilityService`)
- **scientific/**: Scientific calculator specific (`AngleService`, `TrigModeService`)
- **persistence/**: Data persistence (`PreferencesService`)

### Flyout Architecture
Scientific and programmer calculators feature interactive flyout menus:
- **Scientific Flyouts**:
  - `FuncFlyout`: Advanced functions (log, ln, exp, power, root, etc.)
  - `TrigFlyout`: Trigonometry functions (sin, cos, tan, and their inverses)
  - `MenuButtons`: Flyout menu buttons with state management
- **Programmer Flyouts**:
  - `ShiftFlyout`: Bit shift operations
  - `BitwiseFlyout`: Bitwise logic operations (AND, OR, XOR, NOT)

### Programmer Calculator Architecture
Specialized for binary/hex/octal/decimal conversions:
- `BinaryFormatter`: Format numbers with bitwise display
- `BitConverter`: Convert between number bases
- `BitFlipKeypad`: Interactive binary bit manipulation
- `ProgrammerButtonService`: Button state and visibility management

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines

- Follow the code style guidelines defined in [AGENTS.md](AGENTS.md)
- Run `flutter analyze` before committing
- Format code with `dart format .`
- Add tests for new features
- Ensure all tests pass with `flutter test`
- Follow the existing architecture patterns

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Use `snake_case` for files and directories
- Use `PascalCase` for classes, enums, and typedefs
- Use `camelCase` for variables and methods
- Use `SCREAMING_SNAKE_CASE` for top-level constants
- Group imports: dart:, flutter:, package:, project:
- Export from barrel files (e.g., `extensions/extensions.dart`)
- Widget files: `_page.dart`, `_widget.dart`, `_component.dart`
- Provider files: `_provider.dart`, `_service.dart`

### State Management (Riverpod)

- Use `NotifierProvider` for complex state logic
- Use `FutureProvider` for async operations
- Use `Provider` for immutable values/services
- Always call `ref.onDispose()` for cleanup
- Use `@riverpod` code generation when possible
- State classes should use `copyWith()` pattern

## Package Information

- **Name**: calculator
- **Version**: 0.9.0
- **Bundle ID**: io.github.dongfengweixiao.calculator
- **Description**: A powerful calculator application with support for various conversions

## License

This project is licensed under the terms specified in the LICENSE file.

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Calculator engine powered by [wincalc_engine](https://pub.dev/packages/wincalc_engine)
- Inspired by the Windows Calculator application
- App icon sourced from [Streamline Icons](https://www.streamlinehq.com/icons/download/calculator-2--26780)

## Resources

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://flutter.dev/cookbook)
- [Dart Documentation](https://dart.dev/guides)

### Packages
- [Riverpod Documentation](https://riverpod.dev/)
- [wincalc_engine Documentation](https://pub.dev/packages/wincalc_engine)
- [go_router Documentation](https://pub.dev/packages/go_router)
- [window_manager Documentation](https://pub.dev/packages/window_manager)

### Tools
- [Flutter DevTools](https://flutter.dev/tools/devtools/overview)
- [pub.dev](https://pub.dev/)
