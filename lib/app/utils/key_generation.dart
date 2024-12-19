import 'dart:math';
import 'dart:async';

import 'package:cryptoinsight/app/utils/gcd.dart';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> generateKeysAsync(int k) async {
  return await compute(_generateKeys, k);
}

Map<String, dynamic> _generateKeys(int k) {
  BigInt p = generatePrime(k);
  BigInt q = generatePrime(k, exclude: p);
  if (p < q) {
    BigInt temp = p;
    p = q;
    q = temp;
  }
  BigInt A2 = p * p * q;
  BigInt A1;
  do {
    A1 = randomBigInt(BigInt.one << (3 * k + 4), BigInt.one << (3 * k + 6));
  } while (gcd(A1, A2) != BigInt.one);
  BigInt dPrime = modInverse(A1, p * p);
  return {'A1': A1, 'A2': A2, 'dPrime': dPrime, 'p': p, 'q': q, 'k': k};
}

BigInt randomBigInt(BigInt min, BigInt max) {
  Random random = Random.secure();
  BigInt range = max - min;
  BigInt rnd;

  do {
    rnd = BigInt.from(random.nextInt(1 << 32));
    if (range.bitLength > 32) {
      rnd = (rnd << 32) | BigInt.from(random.nextInt(1 << 32));
    }
  } while (rnd >= range);

  return min + rnd;
}

BigInt generatePrime(int bits, {BigInt? exclude}) {
  BigInt min = BigInt.one << (bits - 2);
  BigInt max = BigInt.one << bits;

  int iteration = 0;
  while (true) {
    iteration++;
    BigInt candidate = randomBigInt(min, max);
    print('Iteration $iteration: Generating candidate prime...');
    if (candidate != exclude &&
        candidate % BigInt.from(4) == BigInt.from(3) &&
        isProbablyPrime(candidate)) {
      print('Prime candidate found after $iteration iterations: $candidate');
      return candidate;
    }
  }
}

bool isProbablyPrime(BigInt n, {int iterations = 5}) {
  if (n < BigInt.two) return false;
  if (n == BigInt.two || n == BigInt.from(3)) return true;
  if (n % BigInt.two == BigInt.zero) return false;

  BigInt d = n - BigInt.one;
  int r = 0;
  while (d % BigInt.two == BigInt.zero) {
    d ~/= BigInt.two;
    r++;
  }

  for (int i = 0; i < iterations; i++) {
    BigInt a = randomBigInt(BigInt.two, n - BigInt.one);
    BigInt x = a.modPow(d, n);
    if (x == BigInt.one || x == n - BigInt.one) continue;

    bool isComposite = true;
    for (int j = 0; j < r - 1; j++) {
      x = x.modPow(BigInt.two, n);
      if (x == n - BigInt.one) {
        isComposite = false;
        break;
      }
    }
    if (isComposite) return false;
  }

  return true;
}

BigInt modInverse(BigInt a, BigInt m) {
  BigInt m0 = m;
  BigInt y = BigInt.zero;
  BigInt x = BigInt.one;

  if (m == BigInt.one) return BigInt.zero;

  while (a > BigInt.one) {
    BigInt q = a ~/ m;
    BigInt t = m;
    m = a % m;
    a = t;
    t = y;
    y = x - q * y;
    x = t;
  }

  if (x < BigInt.zero) x += m0;

  return x;
}