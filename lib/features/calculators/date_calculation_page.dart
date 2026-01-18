import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../extensions/extensions.dart';

/// Date calculation mode
enum DateCalculationMode {
  dateDifference,
  addSubtract,
}

/// Date difference result containing formatted difference and total days
class _DateDifferenceResult {
  final String formattedDifference;
  final String totalDays;

  const _DateDifferenceResult({
    required this.formattedDifference,
    required this.totalDays,
  });
}

/// Date calculation page (without header, as header is provided by AppShell)
class DateCalculationPage extends ConsumerStatefulWidget {
  const DateCalculationPage({super.key});

  @override
  ConsumerState<DateCalculationPage> createState() => _DateCalculationPageState();
}

class _DateCalculationPageState extends ConsumerState<DateCalculationPage> {
  DateCalculationMode _mode = DateCalculationMode.dateDifference;
  DateTime? _fromDate;
  DateTime? _toDate;
  DateTime? _startDate;
  int _yearsOffset = 0;
  int _monthsOffset = 0;
  int _daysOffset = 0;
  bool _isAddMode = true;

  @override
  void initState() {
    super.initState();
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
    _startDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // Mode selector
        _buildModeSelector(),

        // Content
        Expanded(
          child: _mode == DateCalculationMode.dateDifference
              ? _buildDateDifferenceContent()
              : _buildAddSubtractContent(),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _ModeSelector(
              selectedMode: _mode,
              onModeSelected: (mode) {
                setState(() {
                  _mode = mode;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateDifferenceContent() {
    final differenceResult = _calculateDateDifference();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From date picker
          _buildDatePicker(
            label: context.l10n.fromDate,
            date: _fromDate,
            onDateChanged: (date) {
              setState(() {
                _fromDate = date;
              });
            },
          ),
          const SizedBox(height: 16),

          // To date picker
          _buildDatePicker(
            label: context.l10n.toDate,
            date: _toDate,
            onDateChanged: (date) {
              setState(() {
                _toDate = date;
              });
            },
          ),
          const SizedBox(height: 24),

          // Result
          Text(
            context.l10n.difference,
            style: TextStyle(
              color: context.theme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            differenceResult.formattedDifference,
            style: TextStyle(
              color: context.theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            differenceResult.totalDays,
            style: TextStyle(
              color: context.theme.textSecondary,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSubtractContent() {
    final resultDate = _calculateAddSubtractDate();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Start date picker
          _buildDatePicker(
            label: context.l10n.startDate,
            date: _startDate,
            onDateChanged: (date) {
              setState(() {
                _startDate = date;
              });
            },
          ),
          const SizedBox(height: 16),

          // Add/Subtract toggle using SegmentedButton
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: true,
                label: Text(context.l10n.add),
                icon: const Icon(Icons.add),
              ),
              ButtonSegment(
                value: false,
                label: Text(context.l10n.subtract),
                icon: const Icon(Icons.remove),
              ),
            ],
            selected: {_isAddMode},
            onSelectionChanged: (Set<bool> selected) {
              setState(() {
                _isAddMode = selected.first;
              });
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return context.theme.accentColor;
                }
                return context.theme.background;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return context.theme.background;
                }
                return context.theme.textPrimary;
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Offset selectors - horizontal layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildOffsetSelector(
                  label: context.l10n.years,
                  value: _yearsOffset,
                  onChanged: (value) {
                    setState(() {
                      _yearsOffset = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOffsetSelector(
                  label: context.l10n.months,
                  value: _monthsOffset,
                  onChanged: (value) {
                    setState(() {
                      _monthsOffset = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOffsetSelector(
                  label: context.l10n.days,
                  value: _daysOffset,
                  onChanged: (value) {
                    setState(() {
                      _daysOffset = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Result
          Text(
            context.l10n.result,
            style: TextStyle(
              color: context.theme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('yyyy-MM-dd').format(resultDate),
            style: TextStyle(
              color: context.theme.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime> onDateChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.theme.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onDateChanged(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: context.theme.divider),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: context.theme.textPrimary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  date != null ? DateFormat('yyyy-MM-dd').format(date) : context.l10n.selectDate,
                  style: TextStyle(
                    color: context.theme.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffsetSelector({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.theme.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: context.theme.divider),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<int>(
            value: value,
            dropdownColor: context.theme.background,
            items: List.generate(
              1000,
              (i) => DropdownMenuItem(
                value: i,
                child: Text(
                  '$i',
                  style: TextStyle(color: context.theme.textPrimary),
                ),
              ),
            ),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            underline: const SizedBox.shrink(),
            isExpanded: true,
          ),
        ),
      ],
    );
  }

  /// Improved date difference calculation using Microsoft-style algorithm
  _DateDifferenceResult _calculateDateDifference() {
    if (_fromDate == null || _toDate == null) {
      return _DateDifferenceResult(
        formattedDifference: context.l10n.selectBothDates,
        totalDays: '',
      );
    }

    DateTime start = _fromDate!;
    DateTime end = _toDate!;

    // Calculate total days first
    final totalDays = end.difference(start).inDays.abs();

    // Ensure start is before end
    if (start.isAfter(end)) {
      final temp = start;
      start = end;
      end = temp;
    }

    // Calculate using a more precise method
    final parts = <String>[];

    // Calculate years
    int years = 0;
    DateTime tempDate = DateTime(start.year, start.month, start.day);
    while (true) {
      final nextYear = DateTime(tempDate.year + 1, tempDate.month, tempDate.day);
      if (!nextYear.isAfter(end)) {
        years++;
        tempDate = nextYear;
      } else {
        break;
      }
    }

    // Calculate months
    int months = 0;
    while (true) {
      final nextMonth = DateTime(
        tempDate.year,
        tempDate.month + 1,
        tempDate.day,
      );
      // Handle month overflow (e.g., Jan 31 -> Feb 28/29)
      if (nextMonth.month == tempDate.month + 1 ||
          (tempDate.month == 12 && nextMonth.month == 1)) {
        // Adjust day if needed
        final lastDayOfNextMonth = DateTime(
          nextMonth.year,
          nextMonth.month + 1,
          0,
        ).day;
        final adjustedDay = nextMonth.day > lastDayOfNextMonth
            ? lastDayOfNextMonth
            : nextMonth.day;

        final adjustedNextMonth = DateTime(
          nextMonth.year,
          nextMonth.month,
          adjustedDay,
        );

        if (!adjustedNextMonth.isAfter(end)) {
          months++;
          tempDate = adjustedNextMonth;
        } else {
          break;
        }
      } else {
        break;
      }
    }

    // Calculate remaining days
    int days = end.difference(tempDate).inDays;

    // Calculate weeks from remaining days
    int weeks = days ~/ 7;
    days = days % 7;

    // Build result string with localized units
    if (years > 0) parts.add('$years ${years > 1 ? context.l10n.years_plural : context.l10n.year}');
    if (months > 0) parts.add('$months ${months > 1 ? context.l10n.months_plural : context.l10n.month}');
    if (weeks > 0) parts.add('$weeks ${weeks > 1 ? context.l10n.weeks_plural : context.l10n.week}');
    if (days > 0) parts.add('$days ${days > 1 ? context.l10n.days_plural : context.l10n.day}');

    final formattedDifference = parts.isEmpty ? '0 ${context.l10n.days_plural}' : parts.join(', ');
    final totalDaysText = '$totalDays ${totalDays == 1 ? context.l10n.day : context.l10n.days_plural}';

    return _DateDifferenceResult(
      formattedDifference: formattedDifference,
      totalDays: totalDaysText,
    );
  }

  /// Calculate date after adding/subtracting duration
  DateTime _calculateAddSubtractDate() {
    if (_startDate == null) {
      return DateTime.now();
    }

    var date = _startDate!;

    // Apply year offset
    if (_yearsOffset > 0) {
      date = DateTime(date.year + _yearsOffset, date.month, date.day);
    }

    // Apply month offset
    if (_monthsOffset > 0) {
      date = DateTime(date.year, date.month + _monthsOffset, date.day);
    }

    // Apply day offset
    if (_daysOffset > 0) {
      if (_isAddMode) {
        date = date.add(Duration(days: _daysOffset));
      } else {
        date = date.subtract(Duration(days: _daysOffset));
      }
    }

    // Handle subtract mode for years and months
    if (!_isAddMode) {
      date = DateTime(date.year - _yearsOffset * 2, date.month, date.day);
      date = DateTime(date.year, date.month - _monthsOffset * 2, date.day);
    }

    return date;
  }
}

class _ModeSelector extends StatelessWidget {
  final DateCalculationMode selectedMode;
  final ValueChanged<DateCalculationMode> onModeSelected;

  const _ModeSelector({
    required this.selectedMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.theme.divider),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<DateCalculationMode>(
        value: selectedMode,
        dropdownColor: context.theme.background,
        items: [
          DropdownMenuItem(
            value: DateCalculationMode.dateDifference,
            child: Text(context.l10n.calculateDifferenceBetweenDates),
          ),
          DropdownMenuItem(
            value: DateCalculationMode.addSubtract,
            child: Text(context.l10n.addOrSubtractFromDate),
          ),
        ],
        onChanged: (mode) {
          if (mode != null) {
            onModeSelected(mode);
          }
        },
        underline: const SizedBox.shrink(),
        isExpanded: true,
      ),
    );
  }
}
