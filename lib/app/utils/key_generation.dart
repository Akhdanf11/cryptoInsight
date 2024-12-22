import 'dart:math';

import 'package:cryptoinsight/app/utils/checkPrime.dart';
import 'package:cryptoinsight/app/utils/gcd.dart';
import 'package:cryptoinsight/app/utils/randomBig.dart';

Map<String, dynamic> generateKeys(int k) {
  print('Generating primes p and q...');
  BigInt p = generatePrime(k);
  print('Generated prime p: $p');
  BigInt q = generatePrime(k, exclude: p);
  print('Generated prime q: $q');

  //   if (p < q) {
  //   BigInt temp = p;
  //   p = q;
  //   q = temp;
  //   print('Swapped values to ensure p > q: p = $p, q = $q');
  // }

  // Calculate A2 = p^2 * q
  BigInt A2 = p * p * q;
  print('Calculated A2 = p^2 * q: $A2');

  // Generate A1 such that gcd(A1, A2) = 1
  BigInt A1;
  BigInt lowerBound = BigInt.one << (3 * k + 4);
  BigInt upperBound = BigInt.one << (3 * k + 6);
  do {
    A1 = randomBigInt(lowerBound, upperBound);
  } while (gcd(A1, A2) != BigInt.one);
  print('Generated A1: $A1');

  // Calculate d = A1^-1 mod (p^2)
  BigInt dPrime = A1.modInverse(p * p);
  print('Calculated dPrime: $dPrime');

  return {
    'A1': A1,
    'A2': A2,
    'dPrime': dPrime,
    'p': p,
    'q': q,
    'k': k,
  };
}

BigInt generatePrime(int bits, {BigInt? exclude}) {
  while (true) {
    BigInt candidate = randomBigInt(BigInt.one << (bits - 1), BigInt.one << bits);
    if (candidate != exclude &&
        candidate % BigInt.from(4) == BigInt.from(3) &&
        isPrime(candidate)) {
      return candidate;
    }
  }
}


