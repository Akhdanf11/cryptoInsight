import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';

class AnalysisController extends GetxController {
  var A1Controller = TextEditingController();
  var A2Controller = TextEditingController();

  // Observables for results
  var bruteForceResult = ''.obs;
  var kraitchikResult = ''.obs;

  // var kraitchikResultP = ''.obs;

  var elapsedBruteForce = 0.obs;
  var elapsedKraitchik = 0.obs;
}

