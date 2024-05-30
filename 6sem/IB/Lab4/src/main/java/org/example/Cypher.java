package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

public class Cypher {
    public static final String pathToFolder = "src/main/texts";
    public static final String fileNameOpen = "text.txt";
    public static final String fileNameEncryptCaesar = "encrypt_caesar.txt";
    public static final String fileNameDecryptCaesar = "decrypt_caesar.txt";
    public static final String fileNameEncryptTrithemius = "encrypt_trithemius.txt";
    public static final String fileNameDecryptTrithemius = "decrypt_trithemius.txt";
    public static final String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // Функция для шифрования текста по аффинной системе подстановки Цезаря
    public static String encryptCaesar(String text, int a, int b) {
        // Проверка на взаимную простоту a и N
        if (gcd(a, alphabet.length()) != 1) {
            throw new IllegalArgumentException("a и N (мощность алфавита) должны быть взаимно простыми");
        }

        text = text.toUpperCase();
        StringBuilder result = new StringBuilder();
        StringBuilder newAlphabet = new StringBuilder();
        for (char character : alphabet.toCharArray()) {
            int originalPosition = alphabet.indexOf(character);
            int newPosition = (a * originalPosition + b) % alphabet.length();
            char newCharacter = alphabet.charAt(newPosition);
            newAlphabet.append(newCharacter);
        }
        for (char character : text.toCharArray()) {
            if (alphabet.contains(String.valueOf(character))) {
                int originalPosition = alphabet.indexOf(character);
                int newPosition = (a * originalPosition + b) % alphabet.length();
                char newCharacter = alphabet.charAt(newPosition);
                result.append(newCharacter);
            } else {
                result.append(character);
            }
        }
        System.out.println("Исходный алфавит: " + alphabet);
        System.out.println("Новый алфавит: " + newAlphabet);
        return result.toString();
    }

    // Функция для расшифровки текста по аффинной системе подстановки Цезаря
    public static String decryptCaesar(String text, int a, int b) {
        int a_inv = modInverse(a, alphabet.length());
        StringBuilder result = new StringBuilder();
        for (char character : text.toCharArray()) {
            if (alphabet.contains(String.valueOf(character))) {
                int originalPosition = alphabet.indexOf(character);
                int newPosition = a_inv * (originalPosition - b + alphabet.length()) % alphabet.length();
                char newCharacter = alphabet.charAt(newPosition);
                result.append(newCharacter);
            } else {
                result.append(character);
            }
        }
        return result.toString();
    }

    // Функция для создания таблицы Трисемуса
    public static String createTrithemiusTable(String keyword) {
        keyword = keyword.toUpperCase();
        StringBuilder table = new StringBuilder(keyword);
        for (char c : alphabet.toCharArray()) {
            if (!table.toString().contains(String.valueOf(c))) {
                table.append(c);
            }
        }
        return table.toString();
    }

    // Функция для шифрования текста по таблице Трисемуса
    public static String encryptTrithemius(String text, String keyword) {
        text = text.toUpperCase();
        String table = createTrithemiusTable(keyword);
        System.out.println("Исходный алфавит: " + alphabet);
        System.out.println("Таблица Трисемуса: " + table);
        StringBuilder result = new StringBuilder();
        for (char character : text.toCharArray()) {
            if (alphabet.contains(String.valueOf(character))) {
                int position = alphabet.indexOf(character);
                char newCharacter = table.charAt(position);
                result.append(newCharacter);
            } else {
                result.append(character);
            }
        }
        return result.toString();
    }

    // Функция для расшифровки текста по таблице Трисемуса
    public static String decryptTrithemius(String text, String keyword) {
        text = text.toUpperCase();
        String table = createTrithemiusTable(keyword);
        StringBuilder result = new StringBuilder();
        for (char character : text.toCharArray()) {
            if (table.contains(String.valueOf(character))) {
                int position = table.indexOf(character);
                char newCharacter = alphabet.charAt(position);
                result.append(newCharacter);
            } else {
                result.append(character);
            }
        }
        return result.toString();
    }

    // Функция для считывания файла
    public static String readFile(String fileName) throws IOException {
        return new String(Files.readAllBytes(Paths.get(pathToFolder, fileName)));
    }

    // Функция для записи шифрованного файла
    public static void writeFile(String fileName, String content) throws IOException {
        Files.write(Paths.get(pathToFolder, fileName), content.getBytes());
    }

    // Функция для вычисления наибольшего общего делителя (НОД)
    public static int gcd(int a, int b) {
        if (b == 0) {
            return a;
        } else {
            return gcd(b, a % b);
        }
    }

    // Функция для нахождения обратного числа по модулю m
    public static int modInverse(int a, int m) {
        a = a % m;
        for (int x = 1; x < m; x++) {
            if ((a * x) % m == 1) {
                return x;
            }
        }
        throw new IllegalArgumentException("Обратное число не существует");
    }

    // Количество появлений символов в строке
    public static Map<Character, Integer> getSymbolAppearances(String str) {
        Map<Character, Integer> symbolAppearances = new HashMap<>();
        for (char c : str.toCharArray()) {
            if (!symbolAppearances.containsKey(c))
                symbolAppearances.put(c, 1);
            else
                symbolAppearances.put(c, symbolAppearances.get(c) + 1);
        }
        return symbolAppearances;
    }

    // Функция распределения частотных свойств
    public static void printSymbolFrequencies(String fileName, String alphabet) throws IOException {
        String text = readFile(fileName).toUpperCase().replace(" ", "");
        Map<Character, Integer> symbolAppearances = getSymbolAppearances(text);

        int totalSymbols = 0;
        for (char c : text.toCharArray()) {
            if (alphabet.indexOf(c) != -1) {
                totalSymbols++;
            }
        }

        System.out.println("Частоты символов для документа " + fileName);
        double totalFrequency = 0.0;
        for (char c : alphabet.toCharArray()) {
            int count = symbolAppearances.getOrDefault(c, 0);
            double frequencyFraction = (double) count / totalSymbols;
            totalFrequency += frequencyFraction;
            System.out.printf("Символ: %c, Частота: %.4f\n", c, frequencyFraction);
        }
        System.out.printf("Итоговая сумма вероятностей: %.4f\n", totalFrequency);
    }
}
