package org.example;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.SecureRandom;



public class Main {
    public static void main(String[] args) {
        String filePathString = "E:\\3course\\6sem\\IB\\Lab12\\text.txt";
        Path filePath = Paths.get(filePathString);

        try {
            System.out.println("====== ЭЦП на основе RSA ======");
            byte[] data = Files.readAllBytes(filePath);

            RSA rsa = new RSA();
            long startTimeRSA = System.currentTimeMillis();
            boolean isValid = rsa.generateKeysSignAndVerify(data);
            long endTimeRSA = System.currentTimeMillis();

            long durationRSA = endTimeRSA - startTimeRSA;
            System.out.println("Время выполнения: " + durationRSA + "мс");

            System.out.println("Public Key: " + rsa.getPublicKeyBase64());
            System.out.println("Private Key: " + rsa.getPrivateKeyBase64());
            System.out.println("Signature: " + rsa.getSignatureBase64());
            System.out.println("Is Valid: " + isValid);

            System.out.println("====== ЭЦП на основе ElGamal ======");
            BigInteger p = new BigInteger("104729"); // Большое простое число
            BigInteger g = new BigInteger("2"); // Генератор
            BigInteger x = new BigInteger("20"); // Закрытый ключ
            BigInteger y = g.modPow(x, p); // Открытый ключ

            String message = "Hello, this is a message";

            long startTimeElGamal = System.currentTimeMillis();
            BigInteger[] signature = ElGamal.signMessage(message, p, g, x);
            System.out.println("Signature: a = " + signature[0] + ", b = " + signature[1]);
            boolean isVerified = ElGamal.verifySignature(message, signature, p, g, y);
            System.out.println("Signature verification: " + (isVerified ? "Valid" : "Invalid"));
            long endTimeElGamal  = System.currentTimeMillis();
            long durationElGamal  = endTimeElGamal  - startTimeElGamal ;
            System.out.println("Время выполнения: " + durationElGamal  + "мс");

            System.out.println("====== ЭЦП на основе Шнорра ======");
            BigInteger snorra_p = new BigInteger("178011508258007219487727449689996692987929429278556871859898032608309048776418951665686606742437481163502156438376198765012974088785867571162393659595694408125107920819558105858289072389148671670950554199119683637585575097129245171840355978023852857095979425687757000783460936105723701163606694540836774579");
            BigInteger snorra_q = new BigInteger("1079522803192077214812010030553127229159359438640");
            BigInteger snorra_g = new BigInteger("2");
            BigInteger snorra_x = new BigInteger("1234567890");

            byte[] snorra_message = "Hello, world!".getBytes();

            long startTimeSnorra = System.currentTimeMillis();
            BigInteger[] snorra_signature = Snorra.generateSignature(snorra_message, snorra_p, snorra_q, snorra_g, snorra_x);
            System.out.println("Signature: h = " + snorra_signature[0] + ", b = " + snorra_signature[1]);

            BigInteger snorra_y = g.modPow(snorra_x, snorra_p);
            boolean snorra_isValid = Snorra.verifySignature(snorra_message, snorra_p, snorra_q, snorra_g, snorra_y, snorra_signature[1], snorra_signature[0]);
            System.out.println("Signature is valid: " + !snorra_isValid);
            long endTimeSnorra  = System.currentTimeMillis();
            long durationSnorra  = endTimeSnorra  - startTimeSnorra;
            System.out.println("Время выполнения: " + durationSnorra  + "мс");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
