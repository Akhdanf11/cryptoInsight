import 'package:flutter/material.dart';
import 'package:refreshed/refreshed.dart';

class AnalysisController extends GetxController {
  var A2Controller = TextEditingController();
  var A1Controller = TextEditingController();
  var bruteForceResult = ''.obs;
  var kraitchikResult = ''.obs;
  var elapsedBruteForce = 0.obs;
  var elapsedKraitchik = 0.obs;
  var isLoading = false.obs;
}

