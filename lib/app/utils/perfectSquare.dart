import 'package:cryptoinsight/app/utils/squareRoot.dart';

bool isPerfectSquare(BigInt n) {
  BigInt sqrtN = sqrtBigInt(n);
  return sqrtN * sqrtN == n;
}