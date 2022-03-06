import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class StorageServices {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
    return;
  }

  Future<String> getDownloadUrl(String imageName) async {
    String downloadUrl = await storage.ref("test/$imageName").getDownloadURL();
    return downloadUrl;
  }
}
