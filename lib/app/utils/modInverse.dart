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