import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/methods/local_methods/folder_notifier.dart';

void saveUrl(BuildContext context, WidgetRef ref, String url) {
  final folders = ref.watch(folderProvider);

  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text('Select Folder'),
        children: folders
            .map(
              (folder) => SimpleDialogOption(
            onPressed: () {
              ref.read(folderProvider.notifier).addUrlToFolder(folder.name, url);
              Navigator.of(context).pop();
            },
            child: Text(folder.name),
          ),
        )
            .toList(),
      );
    },
  );
}