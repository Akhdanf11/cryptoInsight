
import 'dart:math';

import 'package:cryptoinsight/app/utils/checkPrime.dart';
import 'package:cryptoinsight/app/utils/modInverse.dart';
import 'package:cryptoinsight/app/utils/perfectSquare.dart';
import 'package:cryptoinsight/app/utils/squareRoot.dart';

Map<String, BigInt> kraitchikDecrypt(BigInt A2, BigInt A1) {
  print('Starting Kraitchik Decryption for A2 = $A2, A1 = $A1');
  BigInt x = sqrtBigInt(A2);
  BigInt k = BigInt.one;

  while (true) {
    BigInt kn = k * A2;
    BigInt z = (x * x) - kn;

    if (isPerfectSquare(z)) {
      BigInt y = sqrtBigInt(z);
      BigInt pSquared = x + y;
      BigInt q = x - y;

      if (pSquared * q == A2 && pSquared != BigInt.one && q != BigInt.one) {
        BigInt p = sqrtBigInt(pSquared);
        if (p * p == pSquared && isPrime(p)) {
          print('Valid factors found: p = $p, q = $q');
          BigInt d = A1.modInverse(pSquared);
          print('p^2 = $pSquared');
          print('Calculated d = $d');
          return {'p': p, 'q': q, 'd': d, 'k': k, 'pSquared': pSquared};
        }
      }
    }

    // Jika tidak valid, tingkatkan k
    x += BigInt.one;
    k = BigInt.one;
  }
}

