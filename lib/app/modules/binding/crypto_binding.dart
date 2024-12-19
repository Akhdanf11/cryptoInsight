import 'package:cryptoinsight/app/modules/encryption/controllers/encryption_controller.dart';
import 'package:cryptoinsight/app/modules/analysis/controllers/analysis_controller.dart';
import 'package:cryptoinsight/app/modules/home/controllers/home_controller.dart';
import 'package:refreshed/refreshed.dart';

class CryptoBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<HomeController>(() => HomeController()),
      Bind.lazyPut<EncryptionController>(() => EncryptionController()),
      Bind.lazyPut<AnalysisController>(() => AnalysisController()),
    ];
  }
}
