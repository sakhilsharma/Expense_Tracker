import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SettingsScreen
    extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(
      BuildContext context) {
    final themeProvider =
    context.watch<
        ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
          'Settings',
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title:
            const Text(
              'Dark Mode',
            ),

            subtitle:
            const Text(
              'Enable dark theme',
            ),

            value:
            themeProvider
                .isDark,

            onChanged:
                (value) {
              context
                  .read<
                  ThemeProvider>()
                  .toggleTheme(
                  value);
            },
          ),
        ],
      ),
    );
  }
}