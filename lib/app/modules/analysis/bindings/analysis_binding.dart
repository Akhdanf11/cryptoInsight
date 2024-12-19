import 'package:refreshed/refreshed.dart';

import '../controllers/analysis_controller.dart';

class AnalysisBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<AnalysisController>(
        () => AnalysisController(),
      ),
    ];
  }
}
