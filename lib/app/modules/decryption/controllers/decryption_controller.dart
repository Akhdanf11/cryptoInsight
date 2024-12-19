import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refreshed/refreshed.dart';

class DecryptionController extends GetxController {
  RxString decryptedText = ''.obs;

  Future<void> savePlaintextToFile(String plaintext) async {
    try {
      // Request storage permission
      if (!await Permission.storage.request().isGranted) {
        Get.snackbar('Error', 'Storage permission is required');
        return;
      }

      // Get external storage directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception("External storage directory not available");
      }

      // Write to file
      final filePath = '${directory.path}/decrypted_text.txt';
      final file = File(filePath);
      await file.writeAsString(plaintext);

      Get.snackbar('Success', 'Plaintext saved to: $filePath');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save file: ${e.toString()}');
    }
  }
}
