import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refreshed/refreshed.dart';

class PermissionRequestHandler {
  static Future<void> requestManageStoragePermission(BuildContext context) async {
    var status = await Permission.manageExternalStorage.status;

    // Jika izin belum diberikan
    if (!status.isGranted) {
      await showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.storage, size: 48, color: Colors.blue),
                const SizedBox(height: 12),
                Text(
                  "Akses Penyimpanan Diperlukan",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Aplikasi ini membutuhkan izin untuk mengakses penyimpanan untuk dapat menyimpan atau membaca file.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        var permissionStatus = await Permission.manageExternalStorage.request();
                        if (!permissionStatus.isGranted) {
                          Get.snackbar(
                            "Izin Ditolak",
                            "Aplikasi tidak dapat melanjutkan tanpa izin penyimpanan.",
                            snackPosition: SnackPosition.bottom,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Ya, Saya Setuju", style: TextStyle(color: Colors.white),),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup modal
                        Get.snackbar(
                          "Izin Diperlukan",
                          "Akses penyimpanan dibutuhkan untuk melanjutkan.",
                          snackPosition: SnackPosition.bottom,
                        );
                      },
                      child: const Text("Tidak", style: TextStyle(color: Colors.blueAccent),),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
