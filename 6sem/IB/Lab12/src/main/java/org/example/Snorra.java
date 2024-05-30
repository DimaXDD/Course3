package org.example;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.util.Random;


public class Snorra {
    private static final MessageDigest md5;

    static {
        MessageDigest digest;
        try {
            digest = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {
            digest = null; // Handle exception properly in your code
            e.printStackTrace();
        }
        md5 = digest;
    }

    public static BigInteger[] generateSignature(byte[] data, BigInteger p, BigInteger q, BigInteger g, BigInteger x) {
        Random random = new Random();
        int k = random.nextInt(p.intValue() - 1) + 1;
        BigInteger a = g.modPow(BigInteger.valueOf(k), p);
        String str = new String(data);
        byte[] inputBytes = (str + a.toString()).getBytes();
        byte[] hash = md5.digest(concatArrays(inputBytes, new byte[]{0}));
        BigInteger h = new BigInteger(1, concatArrays(hash, new byte[]{0}));
        BigInteger b = BigInteger.valueOf(k).add(x.multiply(h)).mod(q);
        BigInteger[] arr = new BigInteger[2];
        arr[0] = h;
        arr[1] = b;
        return arr;
    }

    public static boolean verifySignature(byte[] data, BigInteger p, BigInteger q, BigInteger g, BigInteger y, BigInteger b, BigInteger h) {
        BigInteger gb = g.modPow(b, p);
        BigInteger X = gb.multiply(y.modPow(h, p)).mod(p);
        String str = new String(data);
        byte[] inputBytes = (str + X.toString()).getBytes();
        byte[] hash = md5.digest(concatArrays(inputBytes, new byte[]{0}));
        BigInteger hCheck = new BigInteger(1, concatArrays(hash, new byte[]{0}));
        return h.equals(hCheck);
    }

    private static byte[] concatArrays(byte[] a, byte[] b) {
        byte[] result = new byte[a.length + b.length];
        System.arraycopy(a, 0, result, 0, a.length);
        System.arraycopy(b, 0, result, a.length, b.length);
        return result;
    }
}
