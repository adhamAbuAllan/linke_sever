import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../status/folder_state.dart';

final folderProvider = StateNotifierProvider<FolderNotifier, List<Folder>>((ref) {
  return FolderNotifier();
});

class FolderNotifier extends StateNotifier<List<Folder>> {
  FolderNotifier() : super([]);

  void addFolder(String name) {
    state = [...state, Folder(name: name)];
  }

  void addUrlToFolder(String folderName, String url) {
    state = state.map((folder) {
      if (folder.name == folderName) {
        return Folder(name: folder.name, urls: [...folder.urls, url]);
      }
      return folder;
    }).toList();
  }
}