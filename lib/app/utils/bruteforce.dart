int bruteForceDecryptSerial(BigInt c, BigInt A1, BigInt A2) {
  int k = 1;
  bool found = false;
  BigInt resultM = BigInt.zero;
  int complexity = 0;

  while (!found) {
    BigInt upperBound = BigInt.one << (2 * k - 1);
    BigInt m = BigInt.one;

    while (!found && m < upperBound) {
      BigInt leftSide = c - (A1 * m.pow(2));
      if (leftSide % A2 == BigInt.zero) {
        BigInt t = leftSide ~/ A2;
        if (t >= BigInt.zero) {
          resultM = m;
          found = true;
        }
      }
      m += BigInt.one;
    }
    k++;
  }

  return found ? resultM.toInt() : -1;
}

Map<String, dynamic> bruteForceDecryptStringSerial(List<BigInt> ciphertexts, BigInt A1, BigInt A2) {
  String resultText = '';

  for (BigInt c in ciphertexts) {
    int result = bruteForceDecryptSerial(c, A1, A2);
    if (result != -1) {
      resultText += String.fromCharCode(result);
    }
  }

  return {
    'text': resultText,
  };
}

