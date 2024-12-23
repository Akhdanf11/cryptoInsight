
import 'dart:math';

import 'package:cryptoinsight/app/utils/checkPrime.dart';
import 'package:cryptoinsight/app/utils/modInverse.dart';
import 'package:cryptoinsight/app/utils/perfectSquare.dart';
import 'package:cryptoinsight/app/utils/squareRoot.dart';

Map<String, BigInt> kraitchikDecrypt(BigInt A2, BigInt A1) {
  print('Starting Kraitchik Decryption for A2 = $A2, A1 = $A1');

  BigInt x = sqrtBigInt(A2);
  print('x: $x');
  BigInt k = BigInt.one;

  while (true) {
    BigInt kn = k * A2;
    BigInt z = (x * x) - kn;

    if (isPerfectSquare(z)) {
      BigInt y = sqrtBigInt(z);

      // Calculate p as gcd(x + y, A2)
      BigInt p = (x + y).gcd(A2);
      BigInt q = (x - y).gcd(A2);

      // Check if p is a valid factor by checking its square root
      BigInt sqrtP = sqrtBigInt(p);
      print('candidate p : $sqrtP, q: $q');

      // Jika akar p adalah prima maka p valid
      if (sqrtP * sqrtP == p && isPrime(sqrtP) && p != BigInt.one && p != A2 && q != BigInt.one && q != A2) {
        print('p adalah valid: akar p = $sqrtP adalah prima.');
        BigInt d = A1.modInverse(p);

        print('p^2 = $p');
        print('Calculated d = $d');

        return {'p': sqrtP, 'q': q, 'd': d, 'k': k, 'pSquared': p};
      }
    }

    // Increment k and x as needed
    k += BigInt.two;
    x += BigInt.one;

  }
}