package org.example;

import java.io.IOException;
import java.util.HashMap;

import static org.example.Enigma.*;

public class Main {

    public static void main(String[] args) {
        try {
            Enigma enigmaEncrypt = new Enigma(0, 0, 0);
            Enigma enigmaDecrypt = new Enigma(0, 0, 0);

            String openMessage = readFile(fileNameOpen);
            //printSymbolFrequencies(fileNameOpen, alphabet);

            long startTimeEncrypt_Enigma = System.nanoTime();
            char[] encryptedMessage = enigmaEncrypt.Encrypt(openMessage.toCharArray());
            long endTimeEncrypt_Enigma = System.nanoTime();
            long durationEncrypt_Enigma = endTimeEncrypt_Enigma- startTimeEncrypt_Enigma;
            System.out.println("Время зашифрования машиной \"Энигма\": " + durationEncrypt_Enigma + " нс");
            Enigma.writeFile(fileNameEncryptEnigma, String.valueOf(encryptedMessage));

            //printSymbolFrequencies(fileNameEncryptEnigma, alphabet);

            long startTimeDecrypt_Enigma = System.nanoTime();
            char[] decryptedMessage = enigmaDecrypt.Decrypt(encryptedMessage);
            long endTimeDecrypt_Enigma = System.nanoTime();
            long durationDecrypt_Enigma = endTimeDecrypt_Enigma - startTimeDecrypt_Enigma;
            System.out.println("Время расшифровки машины \"Энигма\": " + durationDecrypt_Enigma + " нс");
            Enigma.writeFile(fileNameDecryptEnigma, String.valueOf(decryptedMessage));

        } catch (IOException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
