import 'dart:async';
import 'dart:ui';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui_hooks/forui_hooks.dart';
import 'package:link_sever/controller/providers/app_provider.dart';
import 'package:link_sever/view/dialog/dialog_create_url.dart';
import 'package:link_sever/view/dialog/dialog_save_url.dart';
import 'package:url_launcher/url_launcher.dart';

import 'controller/methods/local_methods/folder_notifier.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

main() {
  runApp(ProviderScope(child: MaterialApplication()));
}

class MaterialApplication extends StatelessWidget {
  const MaterialApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      builder: (context, child) {
        final theme = context.theme; // FThemeData
        final colorScheme = context.theme.colorScheme; // FColorScheme
        final typography = context.theme.typography; // FTypography
        return FTheme(
          data: FThemes.violet.dark,
          child: child!,
        );
      },
      home: UrlDetectorScreen(),
    );
  }
}

class UrlDetectorScreen extends ConsumerStatefulWidget {
  const UrlDetectorScreen({super.key});

  @override
  _UrlDetectorScreenState createState() => _UrlDetectorScreenState();
}

class _UrlDetectorScreenState extends ConsumerState<UrlDetectorScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Add lifecycle observer to monitor app state
    WidgetsBinding.instance.addPostFrameCallback((_){
      setState(() {

      });
    });
    WidgetsBinding.instance.addObserver(this);
    // Start clipboard monitoring by calling the provider
    ref.read(clipboardProvider.notifier).checkClipboard();
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final clipboardState = ref.read(clipboardProvider);
      if (clipboardState.copiedText.isEmpty) {
        // Show notification when the app comes back from background
        ref
            .read(notificationProvider)
            .showNotification('Please copy a URL to save it in the app!');
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clipboardState = ref.watch(clipboardProvider);

    return Scaffold(
      backgroundColor: context.theme.scaffoldStyle.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Copied Text:',
              style: context.theme.typography.lg,
            ),
            SizedBox(height: 8),
            Text(
              clipboardState.copiedText.isNotEmpty
                  ? clipboardState.copiedText
                  : 'No URL copied yet',
              style: context.theme.typography.lg,
            ),
            SizedBox(height: 16),
            Text(clipboardState.message, style: context.theme.typography.base),
            if (clipboardState.isUrl)
              ElevatedButton(
                onPressed: () => _launchURL(clipboardState.copiedText),
                child: Text(
                  'Go to url',
                  style: context.theme.typography.xl,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      setState(() {
        // Show error
        // 1if URL cannot be launched
        ref.read(clipboardProvider.notifier).state = ref
            .read(clipboardProvider.notifier)
            .state
            .copyWith(message: 'Could not open the URL.');
      });
    }
  }
}

// class CreateFolderAddUrl extends ConsumerWidget {
//   const CreateFolderAddUrl({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final folders = ref.watch(folderProvider);

//     return Scaffold(
//       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//       backgroundColor: context.theme.scaffoldStyle.backgroundColor,
//       floatingActionButton: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FloatingActionButton.extended(
//               label: Text(
//                 "add Folder",
//                 style: context.theme.typography.base,
//               ),
//               backgroundColor: context.theme.colorScheme.primary,
//               icon: FIcon(
//                 FAssets.icons.folderPlus,
//                 color: context.theme.colorScheme.foreground,
//                 size: 28,
//               ),
//               onPressed: () {
//                 createFolder(context, ref);
//               }),
//           SizedBox(
//             height: 10,
//           ),
//           FloatingActionButton.extended(
//               label: Text(
//                 "add Url",
//                 style: context.theme.typography.base,
//               ),
//               backgroundColor: context.theme.colorScheme.primary,
//               icon: FIcon.data(
//                 Icons.add_link,
//                 color: context.theme.colorScheme.foreground,
//                 size: 28,
//               ),
//               onPressed: () {
//                 saveUrl(context,ref,"https://example.com");
//               }),
//         ],
//       ),
//       body: folders.isEmpty
//           ? Center(
//               child: Text(
//                 "your data is Empty",
//                 style: context.theme.typography.xl3,
//               ),
//             )
//           : ListView.builder(
//               itemCount: folders.length,
//               itemBuilder: (context, index) {
//                 final folder = folders[index];
//                 return ExpansionTile(
//                   iconColor: context.theme.colorScheme.foreground,
//                   collapsedIconColor: Colors.white,
//                   childrenPadding: EdgeInsets.all(10),
//                   backgroundColor: context.theme.colorScheme.primary,
//                   shape: context.theme.cardStyle.decoration.border,
//                   title: Text(
//                     folder.name,
//                     style: context.theme.typography.lg,
//                   ),
//                   children: folder.urls
//                       .map((url) => FTile(
//                               title: Text(
//                             url,
//                             style: context.theme.typography.base,
//                           )))
//                       .toList(),
//                 );
//               },
//             ),
//     );
//   }
// }
// class MainUi extends StatelessWidget {
//   const MainUi({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//     final style = context.theme.style; // FStyle
//
//     return FTheme(
//       data: context.theme,
//       child: ColorfulSafeArea(
//         color: context.theme.colorScheme.primary,
//         child: Scaffold(
//           key: _scaffoldKey,
//           appBar: AppBar(
//             leading: IconButton(
//                 onPressed: () {
//                   _scaffoldKey.currentState?.openDrawer();
//                 },
//                 icon: FIcon(
//                   FAssets.icons.menu,
//                   size: 28,
//                   color: context.theme.colorScheme.foreground,
//                 )),
//             backgroundColor: context.theme.colorScheme.primary,
//           ),
//           backgroundColor: context.theme.scaffoldStyle.backgroundColor,
//           drawer: Drawer(
//             shape: context.theme.cardStyle.decoration.border,
//             backgroundColor: context.theme.scaffoldStyle.backgroundColor,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: FTileGroup(
//                 label: Text("Settings"),
//                 description: const Text('Personalize your experience'),
//                 children: [
//                   FTile(
//                     prefixIcon: FIcon(
//                       FAssets.icons.user,
//                       size: 28,
//                     ),
//                     title: Text('Personalization'),
//                     suffixIcon: FIcon(FAssets.icons.chevronRight),
//                     onPress: () {},
//                   ),
//                   FTile(
//                     prefixIcon: FIcon(
//                       FAssets.icons.wifi,
//                       size: 28,
//                     ),
//                     title: const Text('WiFi'),
//                     details: const Text('Forus Labs (5G)'),
//                     suffixIcon: FIcon(FAssets.icons.chevronRight),
//                     onPress: () {},
//                   ),
//                   FTile(
//                     prefixIcon: FIcon(FAssets.icons.wifi),
//                     title: const Text('WiFi'),
//                     details: const Text('Forus Labs (5G)'),
//                     suffixIcon: FIcon(FAssets.icons.chevronRight),
//                     onPress: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: Center(
//             child: Container(
//               width: 300,
//               height: 300,
//               alignment: Alignment.center,
//               decoration: context.theme.cardStyle.decoration
//                   .copyWith(color: context.theme.colorScheme.primary),
//               child: Text(
//                 "hello World!",
//                 style: context.theme.typography.lg,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
