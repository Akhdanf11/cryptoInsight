import 'package:cryptoinsight/app/utils/decryption.dart';
import 'package:cryptoinsight/app/utils/parse_ciphertext.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:refreshed/refreshed.dart';

class DecryptionView extends StatefulWidget {
  const DecryptionView({Key? key}) : super(key: key);

  @override
  _DecryptionViewState createState() => _DecryptionViewState();
}

class _DecryptionViewState extends State<DecryptionView> {
  final TextEditingController A1Controller = TextEditingController();
  final TextEditingController A2Controller = TextEditingController();
  final TextEditingController dController = TextEditingController();
  final TextEditingController pController = TextEditingController();
  final TextEditingController kController = TextEditingController();
  String decryptedText = '';
  File? selectedFile;

  Future<void> _savePlaintextToFile() async {
    try {
      if (decryptedText.isEmpty) {
        Get.snackbar('Error', 'No decrypted text available to save.');
        return;
      }

      var status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar('Error', 'Storage permission denied.');
        return;
      }

      Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        Get.snackbar('Error', 'Failed to get storage directory.');
        return;
      }

      final file = File('${directory.path}/decrypted_text.txt');
      await file.writeAsString(decryptedText);
      Get.snackbar('Success', 'Plaintext saved to: ${file.path}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laman Dekripsi',
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
            colors: [Colors.white, Colors.white60],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInputField(A1Controller, 'Public Key A1'),
                      _buildInputField(A2Controller, 'Public Key A2'),
                      _buildInputField(dController, 'Private Key d'),
                      _buildInputField(pController, 'Prime p'),
                      _buildInputField(kController, 'Key Length k'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      selectedFile = File(result.files.single.path!);
                    });
                  } else {
                    Get.snackbar('Error', 'No file selected');
                  }
                },
                icon: const Icon(Icons.file_open),
                label: const Text('Select Ciphertext File'),
                style: _buttonStyle(),
              ),

              const SizedBox(height: 8),

              if (selectedFile != null)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Add padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected File: ${selectedFile!.path}',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),


              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () async {
                  if (selectedFile == null) {
                    Get.snackbar('Error', 'Please select a file');
                    return;
                  }
                  try {
                    List<BigInt> ciphertexts = await parseCiphertextFile(selectedFile!);
                    String plaintext = decryptString(
                      ciphertexts,
                      BigInt.parse(dController.text),
                      BigInt.parse(pController.text),
                      BigInt.parse(A1Controller.text),
                      BigInt.parse(A2Controller.text),
                      BigInt.parse(kController.text),
                    );
                    setState(() {
                      decryptedText = plaintext;
                    });
                    Get.snackbar('Success', 'Decryption completed.');
                  } catch (e) {
                    setState(() {
                      decryptedText = 'Decryption failed: $e';
                    });
                    Get.snackbar('Error', 'Decryption failed: $e');
                  }
                },
                icon: const Icon(Icons.lock_open),
                label: const Text('Decrypt'),
                style: _buttonStyle(),
              ),

              const SizedBox(height: 16),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: TextEditingController(text: decryptedText),
                    readOnly: true,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'Decrypted Text',
                      labelStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _savePlaintextToFile,
                icon: const Icon(Icons.save),
                label: const Text('Save Plaintext to File'),
                style: _buttonStyle(),
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
