import 'package:permission_handler/permission_handler.dart';
import 'package:refreshed/refreshed.dart';

Future<void> requestStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    // Permission granted
  } else {
    // Handle permission denial
    Get.snackbar('Permission Denied', 'Storage access is required to save the file.');
  }
}
