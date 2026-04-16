import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:zuvo/constant/app_colors.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zuvo/providers/locale_provider.dart';
import 'package:zuvo/providers/theme_provider.dart';
import 'package:zuvo/views/auth/sign_in_page.dart';

class GetStartPage extends StatelessWidget {
  const GetStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with theme and language toggles
          SizedBox(height: 30),
          Consumer2<ThemeProvider, LocaleProvider>(
            builder: (context, themeProvider, localeProvider, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Theme toggle button
                    IconButton(
                      onPressed: () {
                        final isDarkMode =
                            themeProvider.themeMode == ThemeMode.dark;
                        themeProvider.setThemeMode(
                          isDarkMode ? ThemeMode.light : ThemeMode.dark,
                        );
                      },
                      icon: HugeIcon(
                        icon: themeProvider.themeMode == ThemeMode.dark
                            ? HugeIcons.strokeRoundedSun02
                            : HugeIcons.strokeRoundedMoon02,
                        size: 24,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    // Language toggle button
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              localeProvider.setLocale(Locale('en'));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    localeProvider.locale.languageCode == 'en'
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                'EN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      localeProvider.locale.languageCode == 'en'
                                      ? trueWhite
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              localeProvider.setLocale(Locale('fr'));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    localeProvider.locale.languageCode == 'fr'
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                'FR',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      localeProvider.locale.languageCode == 'fr'
                                      ? trueWhite
                                      : Theme.of(
                                          context,
                                        ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Logo at the top - centered
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.application_name,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          // Bottom section with button and terms
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Elevated Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignInPage()),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.get_started,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Terms and conditions text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${AppLocalizations.of(context)!.conditions_text}\n',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.term_of_service,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.and,
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.privacy_policy,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
