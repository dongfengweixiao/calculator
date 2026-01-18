import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/theme/theme_provider.dart';
import '../../shared/locale/locale_provider.dart';
import '../../core/services/persistence/preferences_service.dart';
import '../../extensions/extensions.dart';

/// Settings page
///
/// Provides application settings including theme mode, about, feedback, privacy, and acknowledgements.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeProvider).mode;
    final currentLanguage = ref.watch(localeProvider).languageCode;
    final currentLocale = ref.watch(resolvedLocaleProvider);
    final supportedLanguages = ref.watch(supportedLanguagesProvider);

    return Scaffold(
      backgroundColor: context.theme.background,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // General Card - Theme Settings
          _buildGeneralCard(context, l10n, themeMode, currentLanguage, currentLocale, supportedLanguages, ref),

          const SizedBox(height: 16),

          // About Card
          _buildAboutCard(context, l10n),

          const SizedBox(height: 16),

          // Feedback Card
          _buildFeedbackCard(context, l10n),

          const SizedBox(height: 16),

          // Privacy Card
          _buildPrivacyCard(context, l10n),

          const SizedBox(height: 16),

          // Acknowledgements Card
          _buildAcknowledgementsCard(context, l10n),
        ],
      ),
    );
  }

  /// General Card - Theme Settings
  Widget _buildGeneralCard(
    BuildContext context,
    AppLocalizations l10n,
    AppThemeMode currentMode,
    String currentLanguage,
    Locale? currentLocale,
    List<LanguageOption> supportedLanguages,
    WidgetRef ref,
  ) {
    final theme = context.theme;

    return _SettingsCard(
      title: l10n.settingsGeneral,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theme mode setting
          Text(
            l10n.themeMode,
            style: TextStyle(
              fontSize: 14,
              color: theme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<AppThemeMode>(
            segments: [
              ButtonSegment(
                value: AppThemeMode.light,
                label: Text(l10n.themeLight),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: AppThemeMode.dark,
                label: Text(l10n.themeDark),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
              ButtonSegment(
                value: AppThemeMode.system,
                label: Text(l10n.themeSystem),
                icon: const Icon(Icons.brightness_auto_outlined),
              ),
            ],
            selected: {currentMode},
            onSelectionChanged: (Set<AppThemeMode> newSelection) {
              ref.read(themeProvider.notifier).setThemeMode(newSelection.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.accent;
                }
                return theme.buttonSubtleDefault;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.brightness == Brightness.dark
                      ? const Color(0xFF000000)
                      : const Color(0xFFFFFFFF);
                }
                return theme.textPrimary;
              }),
            ),
          ),
          const SizedBox(height: 24),
          // Language setting
          Text(
            l10n.language,
            style: TextStyle(
              fontSize: 14,
              color: theme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.buttonSubtleDefault,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: theme.divider,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentLanguage,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: theme.textSecondary,
                ),
                style: TextStyle(
                  color: theme.textPrimary,
                  fontSize: 14,
                ),
                dropdownColor: theme.surface,
                items: supportedLanguages.map((language) {
                  return DropdownMenuItem(
                    value: language.code,
                    child: Row(
                      children: [
                        if (language.code == AppLocale.system)
                          Icon(
                            Icons.language_outlined,
                            color: theme.textSecondary,
                            size: 20,
                          )
                        else
                          Text(
                            language.flagEmoji,
                            style: const TextStyle(fontSize: 16),
                          ),
                        const SizedBox(width: 12),
                        Text(language.getDisplayName(currentLocale)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    ref.read(localeProvider.notifier).setLanguage(newValue);
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return supportedLanguages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language.code,
                      child: Row(
                        children: [
                          if (language.code == AppLocale.system)
                            Icon(
                              Icons.language_outlined,
                              color: theme.accent,
                              size: 20,
                            )
                          else
                            Text(
                              language.flagEmoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                          const SizedBox(width: 12),
                          Text(
                            language.getDisplayName(currentLocale),
                            style: TextStyle(color: theme.accent),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// About Card
  Widget _buildAboutCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return _SettingsCard(
      title: l10n.settingsAbout,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AboutItem(
            label: l10n.settingsAppNameLabel,
            value: l10n.settingsAppName,
          ),
          const SizedBox(height: 8),
          _AboutItem(
            label: l10n.settingsAppVersionLabel,
            value: l10n.settingsAppVersion,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              l10n.settingsCopyright,
              style: TextStyle(
                fontSize: 12,
                color: context.theme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Feedback Card
  Widget _buildFeedbackCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return _SettingsCard(
      title: l10n.settingsFeedback,
      child: Column(
        children: [
          _FeedbackItem(
            icon: Icons.email_outlined,
            title: l10n.settingsSendEmail,
            onTap: () {
              // TODO: Implement email sending
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsSendEmail)),
              );
            },
          ),
          const Divider(height: 1),
          _FeedbackItem(
            icon: Icons.feedback_outlined,
            title: l10n.settingsSubmitTicket,
            onTap: () {
              // TODO: Implement ticket submission
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsSubmitTicket)),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Privacy Card
  Widget _buildPrivacyCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return _SettingsCard(
      title: l10n.settingsPrivacy,
      child: Text(
        l10n.settingsPrivacyContent,
        style: TextStyle(
          fontSize: 14,
          color: context.theme.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }

  /// Acknowledgements Card
  Widget _buildAcknowledgementsCard(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final iconUrl = Uri.parse('https://www.streamlinehq.com/icons/download/calculator-2--26780');

    return _SettingsCard(
      title: l10n.settingsAcknowledgements,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Open source projects
          Text(
            l10n.settingsAcknowledgementsContent,
            style: TextStyle(
              fontSize: 14,
              color: context.theme.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // App icon source
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsIconSource,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.theme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: context.theme.textPrimary,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: l10n.settingsIconSourceContent),
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(iconUrl)) {
                            await launchUrl(
                              iconUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        child: Text(
                          l10n.settingsIconSourceLink,
                          style: TextStyle(
                            color: context.theme.accent,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(text: ' '),
                    TextSpan(text: l10n.settingsIconSourceSuffix),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Settings Card Widget
class _SettingsCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.theme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: context.theme.divider,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.theme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// About Item Widget
class _AboutItem extends StatelessWidget {
  final String label;
  final String value;

  const _AboutItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: context.theme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: context.theme.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Feedback Item Widget
class _FeedbackItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _FeedbackItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.theme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: context.theme.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.theme.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
