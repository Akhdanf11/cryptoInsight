import 'package:refreshed/refreshed.dart';

import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/bindings/analysis_binding.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/analysis/views/analysis_view.dart';
import '../modules/decryption/bindings/decryption_binding.dart';
import '../modules/decryption/views/decryption_view.dart';
import '../modules/encryption/bindings/encryption_binding.dart';
import '../modules/encryption/views/encryption_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.ENCRYPTION,
      page: () => const EncryptionView(),
      binding: EncryptionBinding(),
    ),
    GetPage(
      name: Routes.DECRYPTION,
      page: () => const DecryptionView(),
      binding: DecryptionBinding(),
    ),
    GetPage(
      name: Routes.ANALYSIS,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
    ),
  ];
}
