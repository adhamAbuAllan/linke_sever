import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

final textSmStyleProvider = StateNotifierProvider<BuildContext,FTypography>((
    ref) {
  return FTypography();
});
