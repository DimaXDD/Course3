package org.example;

import java.io.IOException;

import static org.example.Cypher.*;

public class Main {
    public static void main(String[] args) {
        try {
            int rows = 30;
            int cols = 40;

            char[] openText = readFile(fileNameOpen).toCharArray();
            char[][] originalData = convertToTwoDimensionalArray(openText, rows, cols);
            printTable(originalData);

            //printSymbolFrequencies(fileNameOpen, alphabet);

            // Зашифровать маршрутным перестановочным шифром
            long startTimeEncrypt_RouteSwap = System.nanoTime();
            char[] encryptedData = encryptRouteSwap(rows, cols, fileNameOpen);
            long endTimeEncrypt_RouteSwap = System.nanoTime();
            long durationEncrypt_RouteSwap = endTimeEncrypt_RouteSwap - startTimeEncrypt_RouteSwap;
            System.out.println("Время зашифрования маршрутным перестановочным шифром: " + durationEncrypt_RouteSwap + " нс");

            writeFile(fileNameEncryptRoute, new String(encryptedData));

            // Расшифровать маршрутным перестановочным шифром
            long startTimeDecrypt_RouteSwap = System.nanoTime();
            char[][] decryptedData = decryptRouteSwap(rows, cols, fileNameEncryptRoute);
            long endTimeDecrypt_RouteSwap = System.nanoTime();
            long durationDecrypt_RouteSwap = endTimeDecrypt_RouteSwap - startTimeDecrypt_RouteSwap;
            System.out.println("Время расшифровки маршрутного перестановочного шифра: " + durationDecrypt_RouteSwap + " нс");

            StringBuilder sb = new StringBuilder();
            for (char[] row : decryptedData) {
                sb.append(row);
            }
            writeFile(fileNameDecryptRoute, sb.toString());

            //printSymbolFrequencies(fileNameEncryptRoute, alphabet);

            String columnKey = "trubach";  // Фамилия
            String rowKey = "dmitry";     // Имя


            String originalText = readFile(fileNameOpen);
            // Зашифровать шифром множественной перестановки
            long startTimeEncrypt_Multiple = System.nanoTime();
            String encryptedText = encodeMultiple(originalText, columnKey, rowKey);
            long endTimeEncrypt_Multiple = System.nanoTime();
            long durationEncrypt_Multiple = endTimeEncrypt_Multiple  - startTimeEncrypt_Multiple ;
            System.out.println("Время зашифрования шифром множественной перестановки: " + durationEncrypt_Multiple  + " нс");
            writeFile(fileNameEncryptMultiple, encryptedText);

            // Расшифровать шифр множественной перестановки
            long startTimeDecrypt_Multiple = System.nanoTime();
            String decryptedText = decodeMultiple(encryptedText, rowKey, columnKey);
            long endTimeDecrypt_Multiple = System.nanoTime();
            long durationDecrypt_Multiple = endTimeDecrypt_Multiple - startTimeDecrypt_Multiple;
            System.out.println("Время расшифровки шифра множественной перестановки: " + durationDecrypt_Multiple + " нс");

            writeFile(fileNameDecryptMultiple, decryptedText);

            //printSymbolFrequencies(fileNameEncryptMultiple, alphabet);


        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
