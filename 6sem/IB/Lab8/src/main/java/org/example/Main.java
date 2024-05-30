package org.example;

import java.io.IOException;

import static org.example.RSAPSP.*;
import static org.example.RC4.*;

public class Main {
    public static void main(String[] args) throws IOException {
        System.out.println("==== ПСП на основе алгоритма RSA ====");
        RSAPSP psp = new RSAPSP();
        psp.printVariables();
        generateRandomNumbers(psp, 16);

        System.out.println("==== RC4 ====");
        int n = 8;
        RC4 rc4 = new RC4(n);

        //generateText(100000000);

        byte[] key = { 61, 60, 23, 22, 21, 20};
        String openText;
        try {
            openText = readFile(fileNameOpen);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        byte[] sBlock = rc4.initializeSBox(key);
        byte[] keyStream = rc4.generateKeyStream(sBlock, openText.length());
        byte[] encryptedText = rc4.encrypt(openText.getBytes(), keyStream);
        byte[] decryptedText = rc4.decrypt(encryptedText, keyStream);

        writeFile(fileNameEncryptRC4, new String(encryptedText));
        writeFile(fileNameDecryptRC4, new String(decryptedText));

        System.out.println("Encrypt RC4:\t\t" + readFile(fileNameEncryptRC4));
        System.out.println("Decrypt RC4:\t\t" + readFile(fileNameDecryptRC4));

    }
}