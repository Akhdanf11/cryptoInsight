import 'package:cryptoinsight/Permission_req.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:refreshed/refreshed.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final theme = Theme.of(context);

    // Meminta izin akses penyimpanan saat halaman pertama kali dibuka
    Future.delayed(Duration.zero, () async {
      await PermissionRequestHandler.requestManageStoragePermission(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("CryptoInsight"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Fitur",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    icon: Icons.lock,
                    title: "Enkripsi",
                    color: Colors.blue,
                    onTap: () async {
                      await PermissionRequestHandler.requestManageStoragePermission(context);
                      Get.toNamed('/encryption');
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.lock_open,
                    title: "Dekripsi",
                    color: Colors.green,
                    onTap: () async {
                      await PermissionRequestHandler.requestManageStoragePermission(context);
                      Get.toNamed('/decryption');
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.analytics,
                    title: "Kriptanalisis",
                    color: Colors.orange,
                    onTap: () => Get.toNamed('/analysis'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Future<void> _requestManageStoragePermission() async {
  //   var status = await Permission.manageExternalStorage.request();
  //   if (!status.isGranted) {
  //     Get.snackbar(
  //       "Izin Diperlukan",
  //       "Aplikasi memerlukan izin untuk mengakses penyimpanan.",
  //       snackPosition: SnackPosition.bottom,
  //
  //     );
  //   }
  // }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
