BigInt kraitchikDecryptSerial(BigInt c, BigInt A1, BigInt A2) {
  BigInt m = BigInt.one;
  bool found = false;
  BigInt resultM = BigInt.zero;

  while (!found) {
    BigInt w = c - (A1 * m * m);
    if (w % A2 == BigInt.zero) {
      BigInt t = w ~/ A2;
      if (t >= BigInt.zero) {
        resultM = m;
        found = true;
      }
    }
    m += BigInt.one;
  }

  return resultM;
}

Map<String, dynamic> kraitchikDecryptString(List<BigInt> ciphertexts, BigInt A1, BigInt A2) {
  String resultText = '';

  for (BigInt c in ciphertexts) {
    BigInt resultM = kraitchikDecryptSerial(c, A1, A2);
    resultText += String.fromCharCode(resultM.toInt());
  }

  return {
    'text': resultText,
  };
}

