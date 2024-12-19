import 'package:refreshed/refreshed.dart';
import 'package:cryptoinsight/app/data/crypto_data.dart';

class HomeController extends RxController {
  final bruteForceTime = Duration.zero.obs;
  final kraitchikTime = Duration.zero.obs;
  final comparisonData = <AlgorithmComparison>[].obs;

  void updateStatistics(Duration bruteForce, Duration kraitchik) {
    bruteForceTime.value = bruteForce;
    kraitchikTime.value = kraitchik;

    comparisonData.value = [
      AlgorithmComparison(algorithm: "Brute Force", executionTime: bruteForce),
      AlgorithmComparison(algorithm: "Kraitchik", executionTime: kraitchik),
    ];
  }
}
