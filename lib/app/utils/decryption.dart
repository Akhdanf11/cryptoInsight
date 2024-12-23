BigInt modularExponentiation(BigInt base, BigInt exp, BigInt mod) {
  BigInt result = BigInt.one;
  base = base % mod;

  while (exp > BigInt.zero) {
    if (exp % BigInt.two == BigInt.one) {
      result = (result * base) % mod;
    }
    exp = exp ~/ BigInt.two;
    base = (base * base) % mod;
  }

  return result;
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

String decryptString(List<BigInt> ciphertexts, BigInt dPrime, BigInt p, BigInt A1, BigInt A2, BigInt k) {
  k -= BigInt.one;
  print(k);
  List<int> allChars = [];
  for (BigInt c in ciphertexts) {
    try {
      Map<String, dynamic> result = decryptCharacter(c, dPrime, p, A1, A2, k);
      String plaintext = result['m']; // Decrypted character as a string
      if (plaintext.isNotEmpty) {
        allChars.add(plaintext.codeUnitAt(0)); // Convert to ASCII code
      } else {
        print('Decryption returned an empty string for ciphertext: $c');
        allChars.add(0); // Placeholder for empty string
      }
    } catch (e) {
      print('Decryption failed for ciphertext: $c, error: $e');
      allChars.add(0); // Placeholder for failed decryption
    }
  }

  return String.fromCharCodes(allChars); // Convert ASCII codes back to a string
}

Map<String, dynamic> decryptCharacter(BigInt c, BigInt dPrime, BigInt p, BigInt A1, BigInt A2, BigInt k) {
  // Step 1: Calculate w
  BigInt w = (c * dPrime) % (p * p);

  // Step 2: Calculate m_p
  BigInt m_p = modularExponentiation(w, (p + BigInt.one) ~/ BigInt.from(4), p);

  // Step 3: Calculate i
  BigInt m_p_squared = m_p * m_p;
  BigInt i = (w - m_p_squared) ~/ p;

  // Step 4: Calculate j
  BigInt j = (i * modInverse(BigInt.from(2) * m_p, p)) % p;

  // Step 5: Calculate m1
  BigInt m1 = m_p + j * p;

  BigInt m;
  if (m1 < (BigInt.one << ((BigInt.from(2) * k - BigInt.one).toInt()))) {
    print('Condition met: m1 ($m1) < 2^(2k-1) (${BigInt.one << ((BigInt.from(2) * k - BigInt.one).toInt())})');
    m = m1;
  } else {
    print('Condition not met: m1 ($m1) >= 2^(2k-1) (${BigInt.one << ((BigInt.from(2) * k - BigInt.one).toInt())})');
    m = (p * p) - m1;
  }


  // Step 7: Calculate t
  BigInt m_squared = m * m;
  BigInt t = (c - A1 * m_squared) ~/ A2;

  // Debugging output
  print('A1: $A1, A2: $A2, c: $c, m: $m, m_squared: $m_squared, c - A1 * m_squared: ${c - A1 * m_squared}');

  print('c: $c, w: $w, m_p: $m_p, i: $i, j: $j, m1: $m1, m: $m, t: $t, k: $k');

  // Check if t is valid
  if (t < BigInt.zero) {
    print('Decryption failed: t is invalid for c: $c, m: $m');
    throw Exception('Decryption failed: t is invalid');
  }

  String plaintext = String.fromCharCode(m.toInt());
  return {'m': plaintext, 't': t};
}
