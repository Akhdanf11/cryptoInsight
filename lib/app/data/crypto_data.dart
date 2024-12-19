class CryptoProcess {
  final String method;
  final String key;
  final String plaintext;
  final String ciphertext;
  final Duration duration;

  CryptoProcess({
    required this.method,
    required this.key,
    required this.plaintext,
    required this.ciphertext,
    required this.duration,
  });
}

class AlgorithmComparison {
  final String algorithm;
  final Duration executionTime;

  AlgorithmComparison({required this.algorithm, required this.executionTime});
}
