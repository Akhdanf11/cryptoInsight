import 'dart:math';

import 'package:cryptoinsight/app/utils/checkPrime.dart';
import 'package:cryptoinsight/app/utils/modInverse.dart';
import 'package:cryptoinsight/app/utils/squareRoot.dart';

Map<String, BigInt> bruteForceDecrypt(BigInt A2, BigInt A1) {
  print('Starting Brute Force Decryption for A2 = $A2, A1 = $A1');

  for (BigInt p = BigInt.two; p <= sqrtBigInt(A2); p+= BigInt.one) {
    if (A2 % p == BigInt.zero) {
      BigInt pSquared = (p*p);
      print(pSquared);
      BigInt q = A2 ~/ pSquared;

      // Validating the factors
      if (pSquared != BigInt.one && q != BigInt.one && pSquared != A2 && q != A2) {
        // Check if p and q are valid factors of A2
        if (pSquared * q == A2) {
          print('Found factors: p = $p, q = $q');

          // Check if p is prime
          if (isPrime(p)) {
            print('p is valid: p = $p is prime.');
            BigInt d = modInverse(A1, pSquared);

            print('p^2 = $pSquared');
            print('Calculated d = $d');

            return {'p': p, 'q': q, 'd': d};
          }
        }
      }
    }
  }

  return {};
}
