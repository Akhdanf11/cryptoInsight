BigInt gcd(BigInt a, BigInt b) {
  while (b != BigInt.zero) {
    BigInt temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}