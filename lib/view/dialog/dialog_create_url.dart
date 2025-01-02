
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/methods/local_methods/folder_notifier.dart';
void createFolder(BuildContext context, WidgetRef ref) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Create Folder'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Folder Name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(folderProvider.notifier).addFolder(controller.text.trim());
              Navigator.of(context).pop();
            },
            child: Text('Create'),
          ),
        ],
      );
    },
  );
}