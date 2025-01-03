import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:link_sever/controller/providers/app_provider.dart';
import 'package:link_sever/controller/status/clipboard_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ClipboardNotifier extends StateNotifier<ClipboardState> {
  final Ref ref;
  ClipboardNotifier(this.ref) : super(ClipboardState());
bool isValidUrl(String text) {
      return Uri.tryParse(text)?.hasAbsolutePath ?? false;
    }
  Future<void> checkClipboard() async {
    final clipboardContent = await Clipboard.getData('text/plain');
    if (clipboardContent?.text != null && clipboardContent!.text!.isNotEmpty) {
      String copiedText = clipboardContent.text!;
      bool validUrl = isValidUrl(copiedText);

      if (validUrl) {
        state = state.copyWith(
          copiedText: copiedText,
          isUrl: validUrl,
          message: 'URL saved: $copiedText',
        );
        List<String> currentUrls = ref.read(listUrl.notifier).state;

        // Check if copiedUrl is already in the list
        if (!currentUrls.contains(copiedText)) {
          // Add copiedUrl to the list if it's not already there
          ref.read(listUrl).add(copiedText);
        }
      } else {
        state = state.copyWith(
          copiedText: '',
          isUrl: false,
          message: 'Please copy a URL to save it.',
        );
      }
    }

    
  }
}

class OldClipboardNotifier extends StateNotifier<ClipboardState> {
  OldClipboardNotifier() : super(ClipboardState(copiedText: "", isUrl: false));

  // Method to check if the copied text is a URL using regex
  bool isValidUrl(String text) {
    final urlPattern = r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$';
    final regExp = RegExp(urlPattern);
    return regExp.hasMatch(text);
  }

  // Method to check the clipboard content and update state
  Future<void> checkClipboardForUrl({required WidgetRef ref}) async {
    final clipboardContent = await Clipboard.getData('text/plain');
    if (clipboardContent?.text != null && clipboardContent!.text!.isNotEmpty) {
      String copiedUrl = clipboardContent.text!;
      bool validUrl = isValidUrl(copiedUrl);

      if (validUrl) {
        state = state.copyWith(copiedText: copiedUrl, isUrl: validUrl);
        List<String> currentUrls = ref.read(listUrl.notifier).state;

        // Check if copiedUrl is already in the list
        if (!currentUrls.contains(copiedUrl)) {
          // Add copiedUrl to the list if it's not already there
          ref.read(listUrl).add(copiedUrl);
        }

        // _launchURL(text); // Optionally, launch the URL
      }
    }
  }

  // Method to launch the URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
