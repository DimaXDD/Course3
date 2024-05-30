package org.example;

import java.math.BigInteger;
import java.security.SecureRandom;

public class RSAPSP {
    private final BigInteger p;
    private final BigInteger q;
    private final BigInteger n;
    private BigInteger e;
    private BigInteger x;

    public RSAPSP() {
        p = BigInteger.probablePrime(512, new SecureRandom());
        q = BigInteger.probablePrime(512, new SecureRandom());
        n = p.multiply(q);
        BigInteger phi = p.subtract(BigInteger.ONE).multiply(q.subtract(BigInteger.ONE));
        do {
            e = BigInteger.probablePrime(512, new SecureRandom());
        } while (e.compareTo(phi) >= 0 || !e.gcd(phi).equals(BigInteger.ONE));
        x = new BigInteger(512, new SecureRandom());
    }

    public boolean nextBit() {
        x = x.modPow(e, n);
        return x.testBit(0);  // Младший бит числа x
    }

    public static void generateRandomNumbers(RSAPSP psp, int numBits) {
        System.out.print("RSA random number - ");
        StringBuilder bitSequence = new StringBuilder();
        for (int i = 0; i < numBits; i++) {
            boolean bit = psp.nextBit();
            System.out.print(bit ? "1" : "0");
            bitSequence.append(bit ? "1" : "0");
        }
        System.out.println();
        System.out.println("RSA random number (decimal) - " + new BigInteger(bitSequence.toString(), 2)
                .toString(10));
    }


    public void printVariables() {
        System.out.println("p = " + p.toString(10));
        System.out.println("q = " + q.toString(10));
        System.out.println("n = " + n.toString(10));
        System.out.println("e = " + e.toString(10));
        System.out.println("x0 = " + x.toString(10));
    }
}
