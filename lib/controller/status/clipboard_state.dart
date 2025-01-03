// class ClipboardState {
//   final String copiedText;
//   final bool isUrl;

//   ClipboardState({
//     required this.copiedText,
//     required this.isUrl,
//   });

//   ClipboardState copyWith({
//     String? copiedText,
//     bool? isUrl,
//   }) {
//     return ClipboardState(
//       copiedText: copiedText ?? this.copiedText,
//       isUrl: isUrl ?? this.isUrl,
//     );
//   }
// }

class ClipboardState {
  final String copiedText;
  final bool isUrl;
  final String message;

  ClipboardState({
    this.copiedText = '',
    this.isUrl = false,
    this.message = 'Please copy a URL to save it.',
  });

  ClipboardState copyWith({
    String? copiedText,
    bool? isUrl,
    String? message,
  }) {
    return ClipboardState(
      copiedText: copiedText ?? this.copiedText,
      isUrl: isUrl ?? this.isUrl,
      message: message ?? this.message,
    );
  }
}
