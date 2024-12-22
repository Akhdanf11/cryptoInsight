import 'dart:io';
import 'dart:math';
import 'package:cryptoinsight/app/utils/encryption.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cryptoinsight/app/utils/key_generation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart'; // Import untuk clipboard
import 'package:docx_to_text/docx_to_text.dart';
import 'package:google_fonts/google_fonts.dart';

class EncryptionView extends StatefulWidget {
  const EncryptionView({Key? key}) : super(key: key);

  @override
  _EncryptionViewState createState() => _EncryptionViewState();
}

class _EncryptionViewState extends State<EncryptionView> {
  final TextEditingController bitController = TextEditingController();
  String? plaintext;
  String? generatedKey;
  String? ciphertext;
  Map<String, dynamic>? keyDetails;
  bool isLoading = false;
  int keyGenerationTime = 0;
  int encryptionTime = 0;
  File? selectedFile;

  Future<void> _pickFile() async {
    setState(() {
      isLoading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'txt'], // Allow DOCX and TXT files
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        if (result.files.single.extension == 'docx') {
          // For DOCX file, convert it to text
          final bytes = await file.readAsBytes();
          final text = docxToText(bytes);
          setState(() {
            plaintext = text;
          });
          _showSnackbar('DOCX file berhasil dimuat dan dikonversi.');
        } else if (result.files.single.extension == 'txt') {
          // For TXT file, directly read the text content
          String content = await file.readAsString();
          setState(() {
            plaintext = content;
          });
          _showSnackbar('TXT file berhasil dimuat.');
        }
      } else {
        _showSnackbar('Tidak ada file fipilih.');
      }
    } catch (e) {
      _showSnackbar('Error file dipilih: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _generateKey() async {
    if (bitController.text.isNotEmpty) {
      int bitSize = int.parse(bitController.text);
      setState(() {
        isLoading = true;
        keyDetails = null;
      });
      try {
        final start = DateTime.now();
        keyDetails = await generateKeys(bitSize);
        final end = DateTime.now();
        keyGenerationTime = end.difference(start).inMilliseconds;
        _showSnackbar('Pembangkitan Kunci Berhasil.');
      } catch (e) {
        _showSnackbar('Pembangkitan Kunci Gagal: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      _showSnackbar('Masukkan Kunci K');
    }
  }

  void _encryptText() {
    if (plaintext != null && plaintext!.isNotEmpty && keyDetails != null) {
      setState(() {
        isLoading = true;
      });
      try {
        BigInt A1 = keyDetails!['A1'];
        BigInt A2 = keyDetails!['A2'];
        int bitSize = int.parse(bitController.text);

        final start = DateTime.now();
        ciphertext = encryptString(plaintext!, A1, A2, bitSize);
        final end = DateTime.now();
        encryptionTime = end.difference(start).inMilliseconds;
        _showSnackbar('Enkripsi Berhasil.');
      } catch (e) {
        _showSnackbar('Gagal saat Enkripsi: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      _showSnackbar('plaintext atau key details tidak ada.');
    }
  }

  Future<void> _saveCiphertext() async {
    if (ciphertext != null && ciphertext!.isNotEmpty) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        Directory? directory = await getExternalStorageDirectory();
        if (directory != null) {
          File file = File('${directory.path}/ciphertext/ciphertext.txt');
          await file.create(recursive: true);
          await file.writeAsString(ciphertext!);
          _showSnackbar('Ciphertext disimpan pada ${file.path}');
        } else {
          _showSnackbar('Gagal menyimpan di penyipmanan.');
        }
      } else {
        _showSnackbar('Akses penyimpanan ditolak.');
      }
    } else {
      _showSnackbar('Tidak ada ciphertext untuk disimpan.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _showSnackbar('Disimpan di papan klip');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laman Enkripsi',
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
                      _buildInputField(bitController, 'Masukkan Kunci K'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: isLoading ? null : _generateKey,
                icon: const Icon(Icons.key),
                label: const Text('Bangkitkan Kunci'),
                style: _buttonStyle(),
              ),

              const SizedBox(height: 16),

              if (keyDetails != null)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Kunci Publik:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(child: Text('A1: ${keyDetails!['A1']}')),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              color: Colors.blue,
                              onPressed: () => _copyToClipboard(keyDetails!['A1'].toString()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text('A2: ${keyDetails!['A2']}')),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              color: Colors.blue,
                              onPressed: () => _copyToClipboard(keyDetails!['A2'].toString()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Kunci Privat:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Expanded(child: Text('d : ${keyDetails!['dPrime']}')),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              color: Colors.blue,
                              onPressed: () => _copyToClipboard(keyDetails!['dPrime'].toString()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text('p: ${keyDetails!['p']}')),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              color: Colors.blue,
                              onPressed: () => _copyToClipboard(keyDetails!['p'].toString()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text('q: ${keyDetails!['q']}')),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              color: Colors.blue,
                              onPressed: () => _copyToClipboard(keyDetails!['q'].toString()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              if (keyGenerationTime > 0)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Waktu Pembangkitan Kunci:',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$keyGenerationTime ms',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.file_open),
                label: const Text('Pilih Plaintext File'),
                style: _buttonStyle(),
              ),

              const SizedBox(height: 8),

              if (plaintext != null && plaintext!.isNotEmpty)
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
                          'Plaintext:',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8), // Add space between title and content
                        Text(
                          plaintext!,
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: _encryptText,
                icon: const Icon(Icons.lock),
                label: const Text('Enkripsi'),
                style: _buttonStyle(),
              ),

              const SizedBox(height: 16),

              if (ciphertext != null && ciphertext!.isNotEmpty)
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: TextEditingController(text: ciphertext),
                      readOnly: true,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: 'Ciphertext',
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
                onPressed: _saveCiphertext,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Ciphertext ke File'),
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
        keyboardType: TextInputType.number,
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
}
