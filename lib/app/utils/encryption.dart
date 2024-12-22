import 'dart:math';

import 'package:cryptoinsight/app/utils/randomBig.dart';

BigInt encryptCharacter(int m, BigInt A1, BigInt A2, int k) {
  if (m >= 0) {
    BigInt lowerBound = BigInt.one << (4 * k);
    BigInt upperBound = BigInt.one << (4 * k + 1);
    BigInt range = upperBound - lowerBound;
    BigInt t = lowerBound + randomBigInt(BigInt.zero, range);
    BigInt c = A1 * BigInt.from(m).pow(2) + A2 * t;
    return c;
  } else {
    throw Exception('Invalid plaintext character.');
  }
}

String encryptString(String input, BigInt A1, BigInt A2, int k) {
  List<String> ciphertexts = [];
  for (int i = 0; i < input.length; i++) {
    int charCode = input.codeUnitAt(i);
    BigInt c = encryptCharacter(charCode, A1, A2, k);
    ciphertexts.add(c.toString());
  }
  return ciphertexts.join(',');
}
