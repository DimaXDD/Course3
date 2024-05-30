package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Random;
import java.util.concurrent.TimeUnit;

public class RC4 {
    public static final String pathToFolder = "src/main/texts";
    public static final String fileNameOpen = "text.txt";
    public static final String fileNameEncryptRC4 = "encrypt_rc4.txt";
    public static final String fileNameDecryptRC4 = "decrypt_rc4.txt";

    private int n;
    private int mod;

    public RC4(int n) {
        this.n = n;
        mod = (int) Math.pow(2, n);
    }

    // Инициализация S-блока
    public byte[] initializeSBox(byte[] key) {
        int j = 0;
        byte[] sBlock = new byte[mod];

        for (int i = 0; i < mod; i++) {
            sBlock[i] = (byte) i;
        }

        for (int i = 0; i < mod; i++) {
            j = (j + (key[i % key.length] & 0xFF) + (sBlock[i] & 0xFF)) % mod;
            swap(sBlock, i, j);
        }

        return sBlock;
    }


    // Генерация К-слов с помощью ПСП
    public byte[] generateKeyStream(byte[] sBlock, int length) {
        long startTime = System.nanoTime();

        int i = 0;
        int j = 0;
        byte[] keyStream = new byte[length];

        for (int k = 0; k < length; k++) {
            i = (i + 1) % mod;
            j = (j + (sBlock[i] & 0xFF)) % mod;
            swap(sBlock, i, j);
            int t = (sBlock[i] + sBlock[j]) % mod;
            if (t < 0) {
                t += mod;
            }
            keyStream[k] = sBlock[t];
        }

        long endTime = System.nanoTime();
        long elapsedTimeInMillis = TimeUnit.NANOSECONDS.toMillis(endTime - startTime);
        System.out.println("Time elapsed RC4:\t" + (endTime - startTime) + " ns (" + elapsedTimeInMillis + " ms)");

        return keyStream;
    }

    // Зашифрование с помощью RC4
    public byte[] encrypt(byte[] data, byte[] keyStream) {
        byte[] encryptedData = new byte[data.length];

        for (int i = 0; i < data.length; i++) {
            encryptedData[i] = (byte) (data[i] ^ keyStream[i]);
        }

        return encryptedData;
    }

    // Расшифрование с помощью RC4
    public byte[] decrypt(byte[] data, byte[] keyStream) {
        return encrypt(data, keyStream);
    }

    // Вспомогательная функция для того, чтобы менять элементы местами
    private static void swap(byte[] array, int i, int j) {
        byte temp = array[j];
        array[j] = array[i];
        array[i] = temp;
    }

    // Генерация текста
    public static void generateText(int length) throws IOException {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < length; i++) {
            char c = (char) (random.nextInt(26) + 'a'); // генерируем случайную маленькую букву
            sb.append(c);
        }

        writeFile(fileNameOpen, sb.toString());
    }

    public static String readFile(String fileName) throws IOException {
        return new String(Files.readAllBytes(Paths.get(pathToFolder, fileName)));
    }

    public static void writeFile(String fileName, String content) throws IOException {
        Files.write(Paths.get(pathToFolder, fileName), content.getBytes());
    }
}
