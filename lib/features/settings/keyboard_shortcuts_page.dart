import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../core/domain/entities/keyboard_shortcut.dart';
import '../../core/services/input/keyboard_config_service.dart';
import '../../../core/widgets/shortcut_recorder_dialog.dart';

/// Page for viewing and customizing keyboard shortcuts
/// Displays shortcuts grouped by category with option to reassign keys
class KeyboardShortcutsPage extends ConsumerStatefulWidget {
  const KeyboardShortcutsPage({super.key});

  @override
  ConsumerState<KeyboardShortcutsPage> createState() =>
      _KeyboardShortcutsPageState();
}

class _KeyboardShortcutsPageState extends ConsumerState<KeyboardShortcutsPage> {
  late Future<List<KeyboardShortcut>> _shortcutsFuture;
  String _selectedCategory = 'all';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadShortcuts();
  }

  Future<void> _loadShortcuts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final shortcuts = ref.read(keyboardConfigServiceProvider);
      setState(() {
        _shortcutsFuture = Future.value(shortcuts);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _shortcutsFuture = Future.value([]);
        _isLoading = false;
      });
    }
  }

  Future<void> _resetToDefaults() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Shortcuts'),
        content: const Text(
          'Are you sure you want to reset all shortcuts to default? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(keyboardConfigServiceProvider.notifier);
      await service.resetToDefaults();
      await _loadShortcuts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shortcuts reset to defaults')),
        );
      }
    }
  }

  Future<void> _openRecorder(KeyboardShortcut shortcut) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ShortcutRecorderDialog(
        currentShortcut: shortcut.getDisplayLabel(),
        onShortcutRecorded: (key, modifiers) {
          return {
            'key': key,
            'modifiers': modifiers,
          };
        },
      ),
    );

    if (result != null && mounted) {
      // Save the new shortcut
      final updatedShortcut = shortcut.copyWith(
        newKey: result['key'] as LogicalKeyboardKey,
      );

      final service = ref.read(keyboardConfigServiceProvider.notifier);
      final shortcuts = ref.read(keyboardConfigServiceProvider);
      final index = shortcuts.indexWhere((s) => s.id == updatedShortcut.id);
      if (index != -1) {
        final newShortcuts = List<KeyboardShortcut>.from(shortcuts);
        newShortcuts[index] = updatedShortcut;
        await service.saveShortcuts(newShortcuts);
        await _loadShortcuts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard Shortcuts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Minimal Test (4 keys only)',
            onPressed: () => GoRouter.of(context).go('/settings/minimal-hotkey-test'),
          ),
          IconButton(
            icon: const Icon(Icons.science),
            tooltip: 'Test Fn Key Capture',
            onPressed: () => GoRouter.of(context).go('/settings/fn-key-test'),
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset to defaults',
            onPressed: _isLoading ? null : _resetToDefaults,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<KeyboardShortcut>>(
              future: _shortcutsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final shortcuts = snapshot.data!;
                final filteredShortcuts = _selectedCategory == 'all'
                    ? shortcuts
                    : KeyboardConfigService.getShortcutsByCategory(
                        shortcuts,
                        _selectedCategory,
                      );

                if (filteredShortcuts.isEmpty) {
                  return const Center(
                    child: Text('No shortcuts found for this category'),
                  );
                }

                return Column(
                  children: [
                    // Category filter
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _CategoryChip(
                              label: 'All',
                              isSelected: _selectedCategory == 'all',
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = 'all';
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            _CategoryChip(
                              label: 'Basic',
                              isSelected: _selectedCategory == 'basic',
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = 'basic';
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            _CategoryChip(
                              label: 'Common',
                              isSelected: _selectedCategory == 'common',
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = 'common';
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            _CategoryChip(
                              label: 'Scientific',
                              isSelected: _selectedCategory == 'scientific',
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = 'scientific';
                                  });
                                }
                              },
                            ),
                            const SizedBox(width: 8),
                            _CategoryChip(
                              label: 'Programmer',
                              isSelected: _selectedCategory == 'programmer',
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = 'programmer';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Shortcuts list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredShortcuts.length,
                        itemBuilder: (context, index) {
                          final shortcut = filteredShortcuts[index];
                          return _ShortcutListItem(
                            shortcut: shortcut,
                            onTap: () => _openRecorder(shortcut),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor:
          isSelected ? null : theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primaryContainer,
    );
  }
}

class _ShortcutListItem extends StatelessWidget {
  final KeyboardShortcut shortcut;
  final VoidCallback onTap;

  const _ShortcutListItem({
    required this.shortcut,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        shortcut.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(shortcut.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              shortcut.getDisplayLabel(),
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: onTap,
            tooltip: 'Change shortcut',
          ),
        ],
      ),
    );
  }
}
