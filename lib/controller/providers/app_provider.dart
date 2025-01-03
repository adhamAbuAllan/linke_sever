import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_sever/controller/methods/local_methods/clipboard_notifier.dart';
import 'package:link_sever/controller/methods/local_methods/notification_notifier.dart';
import 'package:link_sever/controller/status/clipboard_state.dart';

final clipboardProvider =
    StateNotifierProvider<ClipboardNotifier, ClipboardState>(
  (ref) => ClipboardNotifier(ref),
);
final listUrl = StateProvider<List<String>>((ref) => []);

final notificationProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
// final keyNaviatoin = StateProvider<GlobalKey<NavigatorState>>((ref) => GlobalKey<NavigatorState>());
