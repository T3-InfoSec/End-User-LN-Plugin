import 'dart:math';

import 'package:tlp_connection_plugin/tlp/bigint_prime_helper.dart';


class PrimeGenerator {
  final int bits;
  final Random random;

  PrimeGenerator(this.bits) : random = Random.secure();

  BigInt generatePrime() {
    BigInt prime = randomPrimeBigInt(bits, random: random);
    return prime;
  }

  BigInt generateBigInt() {
    return randomBigInt(bits, random: random);
  }

  BigInt calculateTotient(BigInt p1, BigInt p2) {
    BigInt p1Minus1 = p1 - BigInt.one;
    BigInt p2Minus1 = p2 - BigInt.one;
    return p1Minus1 * p2Minus1;
  }

  BigInt calculateCarmichael(BigInt p1, BigInt p2) {
    BigInt p1Minus1 = p1 - BigInt.one;
    BigInt p2Minus1 = p2 - BigInt.one;
    return _lcm(p1Minus1, p2Minus1);
  }

  BigInt modExp(BigInt base, BigInt exp, BigInt mod) {
    return base.modPow(exp, mod);
  }

  BigInt _lcm(BigInt a, BigInt b) {
    return (a * b) ~/ a.gcd(b);
  }
}

// void main() {
//   int bitsPrimes = 256; // Number of bits for the prime numbers
//   PrimeGenerator primeGen = PrimeGenerator(bitsPrimes);

//   BigInt prime1 = primeGen.generatePrime();
//   BigInt prime2 = primeGen.generatePrime();

//   // Calculate the product of the two primes
//   BigInt product = prime1 * prime2;

//   // // Calculate the Carmichael function of the product
//   BigInt carmichaelp = primeGen.calculateCarmichael(prime1, prime2);

//   // // Output the primes, product, and Carmichael function
//   print("Prime 1: $prime1");
//   print("Prime 2: $prime2");
//   print("Product (Prime1 * Prime2): $product");
//   print("Carmichael(Product): $carmichaelp");

//   // // Choose a sample number 't' (large exponent)
//   BigInt t = BigInt.from(100);

//   // // Calculate 2^t mod carmichaelp
//   BigInt base2 = BigInt.two;
//   BigInt fastExponent = primeGen.modExp(base2, t, carmichaelp);

//   // // Output the result
//   print("2^$t ≡ $fastExponent (mod $carmichaelp)");

//   BigInt baseg = BigInt.from(123);
//   BigInt fastPower = primeGen.modExp(baseg, fastExponent, product);
//   print(fastPower);

//   BigInt slowPower = baseg;
//   for (int i = 0; i < t.toInt(); i++) {
//     slowPower = primeGen.modExp(slowPower, BigInt.two, product);
//   }

//   print("Base raised to fast exponent = $fastPower");
//   print("T-times squared base = $slowPower");
// }
