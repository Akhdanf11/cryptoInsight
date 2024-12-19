import 'dart:io';
import 'package:cryptoinsight/app/modules/analysis/controllers/analysis_controller.dart';
import 'package:cryptoinsight/app/utils/bruteforce.dart';
import 'package:cryptoinsight/app/utils/kraitchik.dart';
import 'package:cryptoinsight/app/utils/parse_ciphertext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:refreshed/refreshed.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  _AnalysisViewState createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  final AnalysisController controller = Get.put(AnalysisController());
  File? selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
      Get.snackbar('Success', 'File selected: ${result.files.single.name}');
    } else {
      Get.snackbar('Error', 'No file selected');
    }
  }

  Future<void> _processAnalysis() async {
    if (selectedFile == null) {
      Get.snackbar('Error', 'Please select a file first.');
      return;
    }

    try {
      List<BigInt> ciphertexts = await parseCiphertextFile(selectedFile!);

      BigInt A1 = BigInt.parse(controller.A1Controller.text);
      BigInt A2 = BigInt.parse(controller.A2Controller.text);

      // Brute Force Decryption
      final bruteStart = DateTime.now();
      Map<String, dynamic> bruteResult = bruteForceDecryptStringSerial(ciphertexts, A1, A2);
      final bruteElapsed = DateTime.now().difference(bruteStart);
      controller.bruteForceResult.value = bruteResult['text'];
      controller.elapsedBruteForce.value = bruteElapsed.inMilliseconds;

      // Kraitchik Decryption
      final kraitchikStart = DateTime.now();
      Map<String, dynamic> kraitchikResult = kraitchikDecryptString(ciphertexts, A1, A2);
      final kraitchikElapsed = DateTime.now().difference(kraitchikStart);
      controller.kraitchikResult.value = kraitchikResult['text'];
      // controller.kraitchikResultP.value = kraitchikResult['privateKeyP'];
      controller.elapsedKraitchik.value = kraitchikElapsed.inMilliseconds;

      Get.snackbar('Success', 'Analysis completed successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to analyze ciphertext: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laman Analisis',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input fields for A1, A2
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInputField(controller.A1Controller, 'Public Key A1'),
                      _buildInputField(controller.A2Controller, 'Public Key A2'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // File selection and processing buttons
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_open),
                label: const Text('Select Ciphertext File'),
                style: _buttonStyle(),
              ),

              if (selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Selected File: ${selectedFile!.path}',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                  ),
                ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _processAnalysis,
                icon: const Icon(Icons.lock_open),
                label: const Text('Process Analysis'),
                style: _buttonStyle(),
              ),

              const SizedBox(height: 16),

              // Display decryption results and complexity
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [ 
                      Obx(() => _buildResultField(controller.bruteForceResult.value, 'Brute Force Result')),
                      const SizedBox(height: 8),
                      // Obx(() => _buildResultField(controller.kraitchikResultP.value, 'Kraitchik Result P')),
                      const SizedBox(height: 8),
                      Obx(() => _buildResultField(controller.kraitchikResult.value, 'Kraitchik Result')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Display elapsed time and complexity
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: ListTile(
                  title: Text(
                    'Elapsed Time Analysis (ms):',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    children: [
                      Obx(() => _buildElapsedTimeRow(
                          'Brute Force Time', controller.elapsedBruteForce.value)),
                      Obx(() => _buildElapsedTimeRow(
                          'Kraitchik Time', controller.elapsedKraitchik.value)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Display Algorithm Complexity Information
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Algorithm Complexity:',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Brute Force Algorithm Complexity:',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Worst Case: O(2^k)\n'
                            'Average Case: O(2^k / 2)\n'
                            'Best Case: O(1)',
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kraitchik Algorithm Complexity:',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Worst Case: O(m)\n'
                            'Average Case: O(m / 2)\n'
                            'Best Case: O(1)',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build the input fields for A1 and A2
  Widget _buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Build the result field for decryption results
  Widget _buildResultField(String text, String label) {
    return TextField(
      controller: TextEditingController(text: text),
      readOnly: true,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Build the elapsed time row for each algorithm
  Widget _buildElapsedTimeRow(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14)),
        Text('$value ms', style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }

  // Button style
  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}


