import 'package:forui/forui.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MaterialApplication());
}

class MaterialApplication extends StatelessWidget {
  const MaterialApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (context, child) => FTheme(
        data: FThemes.zinc.light,
        child: child!,
      ),
      home: MainUi(),
    );
  }
}

class MainUi extends StatelessWidget {
  const MainUi({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme; // FThemeData
    final colorScheme = context.theme.colorScheme; // FColorScheme
    final typography = context.theme.typography; // FTypography
    final style = context.theme.style; // FStyle

    return FTheme(
      data: FThemes.zinc.light, // or FThemes.zinc.dark
      child: FScaffold(
          style:
              theme.scaffoldStyle.copyWith(backgroundColor: colorScheme.error),
          content: Center(
            child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  color: colorScheme.errorForeground,
                  borderRadius: style.borderRadius,
                ),
                child: Text("delete",
                    style: typography.sm
                        .copyWith(color: colorScheme.destructive))),
          )),
    );
  }
}
