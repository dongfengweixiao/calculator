# Calculator

A powerful and feature-rich calculator application built with Flutter, powered by the Microsoft Calculator engine (wincalc_engine).

## Features

### Calculator Modes
- **Standard Calculator**: Basic arithmetic operations with a clean, intuitive interface
- **Scientific Calculator**: Advanced mathematical functions including trigonometry, logarithms, and more
- **Programmer Calculator**: Binary, hexadecimal, and decimal conversions with bitwise operations

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
- **Date Calculation**: Calculate date differences and add/subtract dates
- **History Tracking**: View and reuse previous calculations
- **Responsive Design**: Adaptive UI that works beautifully on all screen sizes
- **Internationalization**: Full support for English and Chinese languages
- **Window Management**: Desktop-ready with window controls (minimize, maximize, close)
- **Theme Support**: Clean, modern design with consistent styling

## Tech Stack

- **Framework**: Flutter 3.10+
- **State Management**: Riverpod
- **Calculator Engine**: wincalc_engine (Microsoft's Calculator Manager)
- **Platform Integration**: FFI for native code interop
- **Window Management**: window_manager for desktop platforms
- **Persistence**: shared_preferences for settings storage
- **Internationalization**: flutter_localizations and intl packages
- **Logging**: Comprehensive logging system with environment-based configuration

## Supported Platforms

- ✅ Android
- ❓ iOS
- ✅ Windows
- ❓ macOS
- ✅ Linux
- ❌ Web

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

3. Run the application:
```bash
# For mobile
flutter run

# For specific platforms
flutter run -d windows
flutter run -d macos
flutter run -d linux
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
├── app/                    # App-level configuration and providers
├── core/                   # Core functionality and shared utilities
│   ├── domain/            # Domain entities and constants
│   ├── services/          # Business logic services
│   ├── theme/             # App theming and styling
│   └── widgets/           # Reusable core widgets
├── features/              # Feature-specific implementations
│   ├── calculator/        # Main calculator views
│   ├── scientific/        # Scientific calculator features
│   ├── programmer/        # Programmer calculator features
│   ├── date_calculation/  # Date calculation feature
│   └── *_converter/       # Various unit converters
├── shared/                # Shared widgets and utilities
│   ├── navigation/        # Navigation logic
│   └── theme/             # Theme management
├── l10n/                  # Internationalization files
└── main.dart             # Application entry point
```

## Architecture

This application follows a clean architecture pattern with clear separation of concerns:

- **Domain Layer**: Business entities and use cases
- **Service Layer**: Business logic and data processing
- **Presentation Layer**: UI components and state management with Riverpod
- **Data Layer**: Persistence and external service integration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Package Information

- **Name**: calculator
- **Version**: 1.0.0+1
- **Bundle ID**: io.github.dongfengweixiao.calculator
- **Description**: A powerful calculator application with support for various conversions

## License

This project is licensed under the terms specified in the LICENSE file.

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Calculator engine powered by [wincalc_engine](https://pub.dev/packages/wincalc_engine)
- Inspired by the Windows Calculator application

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Cookbook](https://flutter.dev/cookbook)
- [Riverpod Documentation](https://riverpod.dev/)
- [wincalc_engine Documentation](https://pub.dev/packages/wincalc_engine)
