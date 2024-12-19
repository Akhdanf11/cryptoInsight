import 'dart:io';

Future<List<BigInt>> parseCiphertextFile(File file) async {
  try {
    String content = await file.readAsString();
    return content
        .split(',')
        .map((e) => BigInt.parse(e.trim()))
        .toList();
  } catch (e) {
    throw Exception('Error parsing ciphertext file: ${e.toString()}');
  }
}