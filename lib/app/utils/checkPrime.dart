import 'package:cryptoinsight/app/utils/randomBig.dart';

bool isPrime(BigInt num) {
  if (num <= BigInt.one) return false;
  if (num == BigInt.two || num == BigInt.from(3)) return true;
  if (num % BigInt.two == BigInt.zero) return false;

  BigInt d = num - BigInt.one;
  int r = 0;
  while (d % BigInt.two == BigInt.zero) {
    d ~/= BigInt.two;
    r++;
  }

  // Menggunakan randomBigInt untuk memilih nilai acak a
  for (int i = 0; i < 5; i++) { // Algoritma Miller-Rabin untuk probabilistik
    BigInt a = randomBigInt(BigInt.two, num - BigInt.one); // Acak antara 2 dan num-1
    BigInt x = a.modPow(d, num);
    if (x == BigInt.one || x == num - BigInt.one) continue;

    bool isComposite = true;
    for (int j = 0; j < r - 1; j++) {
      x = x.modPow(BigInt.two, num);
      if (x == num - BigInt.one) {
        isComposite = false;
        break;
      }
    }
    if (isComposite) return false;
  }

  return true;
}
