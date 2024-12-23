import 'package:cryptoinsight/app/modules/analysis/controllers/analysis_controller.dart';
import 'package:cryptoinsight/app/utils/bruteforce.dart';
import 'package:cryptoinsight/app/utils/kraitchik.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:refreshed/refreshed.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({Key? key}) : super(key: key);

  @override
  _AnalysisViewState createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  final AnalysisController controller = Get.put(AnalysisController());

  Future<void> _processAnalysis() async {
    if (controller.A2Controller.text.isEmpty || controller.A1Controller.text.isEmpty) {
      Get.snackbar('Gagal', 'Harap masukkan nilai A2 dan A1.');
      return;
    }

    try {
      // Kosongkan hasil analisis
      controller.bruteForceResult.value = '';
      controller.kraitchikResult.value = '';
      controller.elapsedBruteForce.value = 0;
      controller.elapsedKraitchik.value = 0;

      // Tampilkan loading
      controller.isLoading.value = true;

      BigInt A2 = BigInt.parse(controller.A2Controller.text);
      BigInt A1 = BigInt.parse(controller.A1Controller.text);

      // Brute Force Decryption
      final bruteStart = DateTime.now();
      Map<String, BigInt> bruteResult = bruteForceDecrypt(A2, A1);
      final bruteElapsed = DateTime.now().difference(bruteStart);
      controller.bruteForceResult.value = bruteResult.isEmpty
          ? 'Tidak ditemukan hasil.'
          : 'p: ${bruteResult['p']}, q: ${bruteResult['q']}, d: ${bruteResult['d']}';
      controller.elapsedBruteForce.value = bruteElapsed.inMilliseconds;

      // Kraitchik Decryption
      final kraitchikStart = DateTime.now();
      Map<String, BigInt> kraitchikResult = await kraitchikDecrypt(A2, A1);
      final kraitchikElapsed = DateTime.now().difference(kraitchikStart);
      controller.kraitchikResult.value = kraitchikResult.isEmpty
          ? 'Tidak ditemukan hasil.'
          : 'p: ${kraitchikResult['p']}, q: ${kraitchikResult['q']}, d: ${kraitchikResult['d']}';

      controller.elapsedKraitchik.value = kraitchikElapsed.inMilliseconds;

      Get.snackbar('Berhasil', 'Proses analisis selesai.');
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memproses analisis: $e');
    } finally {
      // Sembunyikan loading
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kriptanalisis',
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
              // Input fields for A2 and A1
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInputField(controller.A1Controller, 'Kunci Publik A1'),
                      const SizedBox(height: 16),
                      _buildInputField(controller.A2Controller, 'Kunci Publik A2'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Process button
              Obx(() => ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : _processAnalysis,
                icon: const Icon(Icons.lock_open),
                label: controller.isLoading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text('Proses Kriptanalisis'),
                style: _buttonStyle(),
              )),

              const SizedBox(height: 16),

              // Display brute force and kraitchik results
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
                      Obx(() => _buildResultField(controller.bruteForceResult.value, 'Hasil Brute Force')),
                      const SizedBox(height: 8),
                      Obx(() => _buildResultField(controller.kraitchikResult.value, 'Hasil Kraitchik')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Display elapsed time
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: ListTile(
                  title: Text(
                    'Waktu Analisis (ms):',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    children: [
                      Obx(() => _buildElapsedTimeRow(
                          'Waktu Brute Force', controller.elapsedBruteForce.value)),
                      Obx(() => _buildElapsedTimeRow(
                          'Waktu Kraitchik', controller.elapsedKraitchik.value)),
                      const SizedBox(height: 8),
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

  Widget _buildResultField(String text, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          Text(
            text,
            style: GoogleFonts.poppins(),
          ),
        ],
      ),
    );
  }

  Widget _buildElapsedTimeRow(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14)),
        Text('$value ms', style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }

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
