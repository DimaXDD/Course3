package org.example;

import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class ElGamal {
    public static BigInteger[] signMessage(String message, BigInteger p, BigInteger g, BigInteger x) throws NoSuchAlgorithmException {
        BigInteger k;
        do {
            k = new BigInteger(p.bitLength() - 1, new SecureRandom());
        } while (!k.gcd(p.subtract(BigInteger.ONE)).equals(BigInteger.ONE));

        BigInteger a = g.modPow(k, p); // a = g^k mod p
        BigInteger h = hash(message);
        BigInteger kInverse = k.modInverse(p.subtract(BigInteger.ONE));
        BigInteger b = kInverse.multiply(h.subtract(x.multiply(a))).mod(p.subtract(BigInteger.ONE));

        return new BigInteger[]{a, b};
    }

    public static boolean verifySignature(String message, BigInteger[] signature, BigInteger p, BigInteger g, BigInteger y) throws NoSuchAlgorithmException {
        BigInteger a = signature[0];
        BigInteger b = signature[1];
        BigInteger h = hash(message);

        BigInteger leftSide = y.modPow(a, p).multiply(a.modPow(b, p)).mod(p);
        BigInteger rightSide = g.modPow(h, p);

        return leftSide.equals(rightSide);
    }

    public static BigInteger hash(String message) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(message.getBytes());
        return new BigInteger(1, hash);
    }
}
