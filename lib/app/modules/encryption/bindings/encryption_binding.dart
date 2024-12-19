import 'package:refreshed/refreshed.dart';

import '../controllers/encryption_controller.dart';

class EncryptionBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<EncryptionController>(
        () => EncryptionController(),
      ),
    ];
  }
}
