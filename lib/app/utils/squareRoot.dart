BigInt sqrtBigInt(BigInt n) {
  BigInt x = n;
  BigInt y = (x + (n ~/ x)) ~/ BigInt.two;

  while (y < x) {
    x = y;
    y = (x + (n ~/ x)) ~/ BigInt.two;
  }
  return x;
}