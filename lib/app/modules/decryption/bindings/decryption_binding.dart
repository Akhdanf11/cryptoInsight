import 'package:refreshed/refreshed.dart';

import '../controllers/decryption_controller.dart';

class DecryptionBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<DecryptionController>(
        () => DecryptionController(),
      ),
    ];
  }
}
