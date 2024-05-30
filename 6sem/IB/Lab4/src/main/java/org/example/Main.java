package org.example;

import java.io.IOException;

import static org.example.Cypher.*;

public class Main {
    public static void main(String[] args) throws IOException {
        System.out.println("Аффинная система подстановки Цезаря");
        int a = 7;
        int b = 7;

        String text = readFile(fileNameOpen);

        long startTimeEncrypt_Caesar = System.nanoTime();
        String encryptedText_Caesar = encryptCaesar(text, a, b);
        long endTimeEncrypt_Caesar = System.nanoTime();
        long durationEncrypt_Caesar = (endTimeEncrypt_Caesar - startTimeEncrypt_Caesar) / 1000000;
        System.out.println("Время зашифрования аффинной системой подстановки Цезаря: " + durationEncrypt_Caesar + " мс");

        writeFile(fileNameEncryptCaesar, encryptedText_Caesar);

        long startTimeDecrypt_Caesar = System.nanoTime();
        String decryptedText_Caesar = decryptCaesar(encryptedText_Caesar, a, b);
        long endTimeDecrypt_Caesar = System.nanoTime();
        long durationDecrypt_Caesar = (endTimeDecrypt_Caesar - startTimeDecrypt_Caesar) / 1000000;
        System.out.println("Время расшифровки аффинной системы подстановки Цезаря: " + durationDecrypt_Caesar + " мс");

        writeFile(fileNameDecryptCaesar, decryptedText_Caesar);

        printSymbolFrequencies(fileNameOpen, alphabet);
        printSymbolFrequencies(fileNameEncryptCaesar, alphabet);

        System.out.println("====================================");

        System.out.println("Таблица Трисемуса");
        String keyword = "security";

        long startTimeEncrypt_Trithemius = System.nanoTime();
        String encryptedText_Trithemius = encryptTrithemius(text, keyword);
        long endTimeEncrypt_Trithemius = System.nanoTime();
        long durationEncrypt_Trithemius = (endTimeEncrypt_Trithemius - startTimeEncrypt_Trithemius) / 1000000;
        System.out.println("Время зашифрования таблицей Трисемуса: " + durationEncrypt_Trithemius + " мс");

        writeFile(fileNameEncryptTrithemius, encryptedText_Trithemius);

        long startTimeDecrypt_Trithemius = System.nanoTime();
        String decryptedText_Trithemius = decryptTrithemius(encryptedText_Trithemius, keyword);
        long endTimeDecrypt_Trithemius = System.nanoTime();
        long durationDecrypt_Trithemius = (endTimeDecrypt_Trithemius - startTimeDecrypt_Trithemius) / 1000000;
        System.out.println("Время расшифровки таблицы Трисемуса: " + durationDecrypt_Trithemius + " мс");

        writeFile(fileNameDecryptTrithemius, decryptedText_Trithemius);

        printSymbolFrequencies(fileNameOpen, alphabet);
        printSymbolFrequencies(fileNameEncryptTrithemius, alphabet);

        System.out.println("====================================");

    }
}