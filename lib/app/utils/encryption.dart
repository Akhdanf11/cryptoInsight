import 'dart:math';

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

BigInt randomBigInt(BigInt min, BigInt max) {
  BigInt diff = max - min;
  int bitLength = diff.bitLength;
  BigInt randomValue;
  do {
    randomValue = BigInt.parse(
      List.generate((bitLength + 7) ~/ 8, (_) => Random.secure().nextInt(256))
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join(),
      radix: 16,
    );
  } while (randomValue >= diff);
  return min + randomValue;
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
