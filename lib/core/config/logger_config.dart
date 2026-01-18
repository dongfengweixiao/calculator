import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

/// Configure logging for the application
///
/// Call this once in main() before running the app
///
/// Environment-specific behavior:
/// - Debug mode: All logs enabled, colored console output
/// - Profile mode: INFO and above, colored console output
/// - Release mode: WARNING and above only, no console output
void configureLogging() {
  // Set appropriate log level based on build mode
  Logger.root.level = _getLogLevelForEnvironment();

  // Add console handler only for debug/profile builds
  if (!kReleaseMode) {
    Logger.root.onRecord.listen(_consoleLogHandler);
  }

  // Log initialization
  final log = Logger('LogConfig');
  if (!kReleaseMode) {
    log.info(
      'Logging initialized: ${_getBuildMode()} mode, '
      'level: ${Logger.root.level.name}'
    );
  }
}

/// Get appropriate log level based on build configuration
Level _getLogLevelForEnvironment() {
  if (kDebugMode) {
    // Debug: Show everything for development
    return Level.ALL;
  } else if (kProfileMode) {
    // Profile: Testing/QA - show info and above
    return Level.INFO;
  } else {
    // Release: Production - only warnings and errors
    return Level.WARNING;
  }
}

/// Get current build mode string
String _getBuildMode() {
  if (kDebugMode) return 'DEBUG';
  if (kProfileMode) return 'PROFILE';
  return 'RELEASE';
}

/// Console log handler with colors (disabled in release builds)
void _consoleLogHandler(LogRecord record) {
  final color = _getColorForLevel(record.level);
  final prefix = _getPrefixForLevel(record.level);
  final time = record.time.toIso8601String().substring(11, 23);

  // Format: [TIME] [LEVEL] [LoggerName] Message
  // ignore: avoid_print
  print('$color[$time] [$prefix] [${record.loggerName}] ${record.message}\x1B[0m');

  // Print error and stack if present
  if (record.error != null) {
    // ignore: avoid_print
    print('$color  Error: ${record.error}\x1B[0m');
  }
  if (record.stackTrace != null) {
    // ignore: avoid_print
    print('$color  StackTrace:\n${record.stackTrace}\x1B[0m');
  }
}

/// Get ANSI color for log level
String _getColorForLevel(Level level) {
  if (level >= Level.SEVERE) return '\x1B[31m'; // Red
  if (level >= Level.WARNING) return '\x1B[33m'; // Yellow
  if (level >= Level.INFO) return '\x1B[32m'; // Green
  if (level >= Level.CONFIG) return '\x1B[36m'; // Cyan
  if (level >= Level.FINE) return '\x1B[90m'; // Gray
  return '\x1B[37m'; // White
}

/// Get prefix string for log level
String _getPrefixForLevel(Level level) {
  if (level >= Level.SEVERE) return 'SEVERE';
  if (level >= Level.WARNING) return 'WARN';
  if (level >= Level.INFO) return 'INFO';
  if (level >= Level.CONFIG) return 'CONFIG';
  if (level >= Level.FINE) return 'FINE';
  if (level >= Level.FINER) return 'FINER';
  if (level >= Level.FINEST) return 'FINEST';
  return level.name.toUpperCase();
}

/// Extension to add convenient logging methods
extension LoggerExt on Logger {
  /// Log structured data (useful for debugging complex objects)
  void data(String message, Map<String, dynamic> data) {
    fine('$message: ${_formatData(data)}');
  }

  /// Log performance timing
  void performance(String operation, Duration duration) {
    fine('Performance: $operation took ${duration.inMilliseconds}ms');
  }

  /// Format data for logging
  String _formatData(Map<String, dynamic> data) {
    final buffer = StringBuffer();
    buffer.write('{');
    data.forEach((key, value) {
      if (buffer.length > 1) buffer.write(', ');
      buffer.write('$key: $value');
    });
    buffer.write('}');
    return buffer.toString();
  }
}

/// Utility to measure execution time
class PerformanceTracker {
  final String operation;
  final Logger logger;
  final Stopwatch _stopwatch = Stopwatch();

  PerformanceTracker(this.operation, this.logger);

  void start() => _stopwatch.start();
  void stop() {
    _stopwatch.stop();
    logger.performance(operation, _stopwatch.elapsed);
  }
}

/// Extension to easily create performance trackers
extension LoggerPerformanceExt on Logger {
  PerformanceTracker track(String operation) {
    return PerformanceTracker(operation, this)..start();
  }
}
