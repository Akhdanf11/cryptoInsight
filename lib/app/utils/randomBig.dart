import 'dart:math';

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