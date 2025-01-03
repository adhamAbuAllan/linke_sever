import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../../controller/methods/local_methods/folder_notifier.dart';

void createFolder(BuildContext context, WidgetRef ref) {
  final TextEditingController controller = TextEditingController();

  showAdaptiveDialog(
    context: context,
    builder: (context) {
      return FDialog(
        title: Text('Create Folder'),
        body: FTextField(
          controller: controller,
          hint: "folder name",
        ),
        actions: [
          FButton(
            onPress: () {
              ref
                  .read(folderProvider.notifier)
                  .addFolder(controller.text.trim());
              Navigator.of(context).pop();
            },
            label: Text('Create'),
          ),
        ],
      );
    },
  );
}
